class SchedulePage < ApplicationRecord

  validates :url, presence: true, uniqueness: true
  validates :datetime, presence: true

  attr_accessor :content

  def self.download(year, month, content = nil)
    datetime = Time.zone.local(year, month, 1, 0, 0, 0)
    url = "https://keiba.yahoo.co.jp/schedule/list/#{datetime.year}/?month=#{datetime.month}"

    if content.nil?
      content = NetModule.download_with_get(url)
    end

    schedule_page = find_by_url(url)
    if schedule_page.nil?
      schedule_page = SchedulePage.new(url: url, datetime: datetime)
    else
      schedule_page.datetime = datetime
    end
    schedule_page.content = content

    schedule_page
  end

  def parse
    doc = Nokogiri::HTML.parse(@content, nil, "UTF-8")

    page_data = doc.xpath("//table[contains(@class, 'scheLs')]/tbody/tr/td[position()=1 and @rowspan='2']").map do |td|
      course_info = {}

      td.text.match(/([0-9]+)日/) do |day|
        course_info[:date] = Time.zone.local(self.datetime.year, \
          self.datetime.month, \
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
        Rails.logger.warn "SchedulePage(datetime=#{self.datetime.to_s})#parse: skip line: td=#{td.inspect}"
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

end
