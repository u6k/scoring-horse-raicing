class SchedulePage
  extend ActiveSupport::Concern

  attr_reader :date, :url

  def self.find_all
    schedule_pages = NetModule.get_s3_bucket.objects(prefix: "html/schedule/schedule.").map do |s3_obj|
      if s3_obj.key.match(/schedule\.([0-9]+)\.html$/)
        date_str = s3_obj.key.match(/schedule\.([0-9]+)\.html/)[1]
        SchedulePage.new(date_str[0..3].to_i, date_str[4..5].to_i)
      end
    end

    schedule_pages.compact
  end

  def initialize(year, month, content = nil)
    @date = Time.zone.local(year, month, 1)

    if not content.nil?
      @content = content
    elsif exists?
      @content = NetModule.get_s3_object(NetModule.get_s3_bucket, _build_s3_name)
    else
      @content = nil
    end
  end

  def download!
    url = "https://keiba.yahoo.co.jp/schedule/list/#{@date.year}/?month=#{@date.month}"
    @content = NetModule.download_with_get(url)
  end

  def download_from_s3!
    # FIXME
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
    page_data = _parse

    if page_data.nil?
      return nil
    end

    page_data.map do |course_info|
      RaceListPage.new(course_info[:race_id])
    end
  end

  def same?(obj)
    if not obj.instance_of?(SchedulePage)
      return false
    end

    if self.date != obj.date \
      || self.url != obj.url
      return false
    end

    self.race_list_pages.each do |p1|
      p2 = obj.race_list_pages.find { |p| p1.race_id == p.race_id }

      if not p1.same?(p2)
        return false
      end
    end

    true
  end

  private

  def _parse
    if @content.nil?
      return nil
    end

    doc = Nokogiri::HTML.parse(@content, nil, "UTF-8")

    page_data = doc.xpath("//table[contains(@class, 'scheLs')]/tbody/tr/td[position()=1 and @rowspan='2']").map do |td|
      course_info = {}

      td.text.match(/([0-9]+)日/) do |day|
        course_info[:date] = Time.zone.local(@date.year, @date.month, day[1].to_i, 0, 0, 0)
      end

      if not td.xpath("a").empty?
        td.xpath("a").attribute("href").value.match(/^\/race\/list\/([0-9]+)\/$/) do |path|
          course_info[:url] = "https://keiba.yahoo.co.jp" + path[0]
          course_info[:race_id] = path[1]
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
