class SchedulePage
  extend ActiveSupport::Concern

  attr_reader :date, :race_list_pages

  def self.find_all
    schedule_pages = NetModule.get_s3_bucket.objects(prefix: Rails.application.secrets.s3_folder + "/schedule/schedule.").map do |s3_obj|
      s3_obj.key.match(/schedule\.([0-9]+)\.html$/) do |path|
        SchedulePage.new(path[1][0..3].to_i, path[1][4..5].to_i)
      end
    end

    schedule_pages.compact
  end

  def initialize(year, month, content = nil)
    @date = Time.zone.local(year, month, 1)
    @content = content

    _parse
  end

  def download_from_web!
    @content = NetModule.download_with_get(_build_url)

    _parse
  end

  def download_from_s3!
    @content = NetModule.get_s3_object(NetModule.get_s3_bucket, _build_s3_path)

    _parse
  end

  def exists?
    NetModule.get_s3_bucket.object(_build_s3_path).exists?
  end

  def valid?
    (not @race_list_pages.nil?)
  end

  def save!
    if not valid?
      raise "Invalid"
    end

    NetModule.put_s3_object(NetModule.get_s3_bucket, _build_s3_path, @content)
  end

  def same?(obj)
    if not obj.instance_of?(SchedulePage)
      return false
    end

    if self.date != obj.date \
      || self.race_list_pages.nil? != obj.race_list_pages.nil?
      return false
    end

    if (not self.race_list_pages.nil?) && (not obj.race_list_pages.nil?)
      self.race_list_pages.each do |race_list_page_self|
        race_list_page_obj = obj.race_list_pages.find { |r| r.race_id == race_list_page_self.race_id }

        return false if not race_list_page_self.same?(race_list_page_obj)
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

    @race_list_pages = doc.xpath("//table[contains(@class, 'scheLs')]/tbody/tr/td[position()=1 and @rowspan='2']/a").map do |a|
      a.attribute("href").value.match(/^\/race\/list\/([0-9]+)\/$/) do |path|
        RaceListPage.new(path[1])
      end
    end

    @race_list_pages.compact!
    if @race_list_pages.empty?
      @race_list_pages = nil
    end
  end

  def _build_url
    url = "https://keiba.yahoo.co.jp/schedule/list/#{@date.year}/?month=#{@date.month}"
  end

  def _build_s3_path
    Rails.application.secrets.s3_folder + "/schedule/schedule.#{@date.strftime('%Y%m')}.html"
  end

end
