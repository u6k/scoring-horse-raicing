class SchedulePage < ApplicationRecord

  validates :url, presence: true, uniqueness: true
  validates :date, presence: true
  validate :_validate

  attr_accessor :content
  has_many :race_list_pages

  before_save :_put_html
  after_initialize :_get_html

  def self.download(year, month, content = nil)
    date = Time.zone.local(year, month, 1, 0, 0, 0)
    url = "https://keiba.yahoo.co.jp/schedule/list/#{date.year}/?month=#{date.month}"

    if content.nil?
      content = NetModule.download_with_get(url)
    end

    schedule_page = find_by_url(url)
    if schedule_page.nil?
      schedule_page = SchedulePage.new(url: url, date: date)
    else
      schedule_page.date = date
    end
    schedule_page.content = content

    schedule_page
  end

  def self.find_by_date(year, month)
    target_date = Time.zone.local(year, month, 1, 0, 0, 0)

    schedule_pages = SchedulePage.where(date: target_date)

    schedule_pages.empty? ? nil : schedule_pages[0]
  end

  def same?(obj)
    if not obj.instance_of?(SchedulePage)
      false
    elsif self.url != obj.url \
      || self.parse != obj.parse
      false
    else
      true
    end
  end

  def parse
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

  def download_race_list_pages
    page_data = parse

    if page_data.nil?
      nil
    else
      race_list_pages = page_data.map do |course_info|
        RaceListPage.download(self, course_info[:url], course_info[:date], course_info[:course_name])
      end
    end
  end

  private

  def _validate
    page_data = parse

    if page_data.nil? \
      || page_data.length == 0
      errors.add(:url, "Invalid html")
    end
  end

  def _build_file_path
    "html/#{date.strftime('%Y%m')}/schedule.html"
  end

  def _put_html
    bucket = NetModule.get_s3_bucket

    file_path = _build_file_path
    NetModule.put_s3_object(bucket, file_path, @content)
  end

  def _get_html
    bucket = NetModule.get_s3_bucket

    file_path = _build_file_path
    if bucket.object(file_path).exists?
      @content = NetModule.get_s3_object(bucket, file_path)
    end
  end

end
