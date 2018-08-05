class SchedulePage
  extend ActiveSupport::Concern

  def self.find_all
    NetModule.get_s3_bucket.objects(prefix: "html/schedule/schedule.").map do |s3_obj|
      date_str = s3_obj.key.match(/schedule\.([0-9]+)\.html/)[1]
      SchedulePage.new(date_str[0..3].to_i, date_str[4..5].to_i)
    end
  end

  def initialize(year, month, content = nil)
    @date = Time.zone.local(year, month, 1)
    @content = content
  end

  def download!
    url = "https://keiba.yahoo.co.jp/schedule/list/#{@date.year}/?month=#{@date.month}"
    @content = NetModule.download_with_get(url)
  end

  def exists?
    NetModule.get_s3_bucket.object(_build_s3_name).exists?
  end

  def valid?
    (not _parse.nil?)
  end

  def save!
    if not valid?
      raise "Invalid"
    end

    NetModule.put_s3_object(NetModule.get_s3_bucket, _build_s3_name, @content)
  end

  def race_list_pages
    if not valid?
      return nil
    end

    _parse.map do |course_info|
      RaceListPage.new(course_info[:url], course_info[:date], course_info[:course_name])
    end
  end

  private

  def _parse
    if @content.nil? && exists?
      @content = NetModule.get_s3_object(NetModule.get_s3_bucket, _build_s3_name)
    end

    if @content.nil?
      return nil
    end

    doc = Nokogiri::HTML.parse(@content, nil, "UTF-8")

    page_data = doc.xpath("//table[contains(@class, 'scheLs')]/tbody/tr/td[position()=1 and @rowspan='2']").map do |td|
      course_info = {}

      td.text.match(/([0-9]+)日/) do |day|
        course_info[:date] = Time.zone.local(self.date.year, \
          self.date.month, \
          day[1].to_i, \
          0, 0, 0)
      end

      if not td.xpath("a").empty?
        td.xpath("a").attribute("href").value.match(/^\/race\/list\/[0-9]+\/$/) do |path|
          course_info[:url] = "https://keiba.yahoo.co.jp" + path[0]
        end

        td.xpath("a").text.match(/^[0-9]+回(.+?)[0-9]+日$/) do |course|
          course_info[:course_name] = course[1]
        end
      end

      if course_info[:date].nil?
        Rails.logger.warn "SchedulePage(date=#{self.date.to_s})#parse: skip line: td=#{td.inspect}"
        nil
      elsif course_info[:url].nil?
        nil
      else
        course_info
      end
    end

    page_data.compact!

    if page_data.empty?
      nil
    else
      page_data
    end
  end

  def _build_s3_name
    "html/schedule/schedule.#{@date.strftime('%Y%m')}.html"
  end

end
