class RaceListPage < ApplicationRecord

  validates :url, presence: true, uniqueness: true
  validates :date, presence: true
  validates :course_name, presence: true

  attr_accessor :content
  belongs_to :schedule_page

  def self.download(schedule_page, url, date, course_name, content = nil)
    if content.nil?
      content = NetModule.download_with_get(url)
    end

    race_list_page = find_by_url(url)
    if race_list_page.nil?
      race_list_page = schedule_page.race_list_pages.build(url: url, date: date, course_name: course_name)
    else
      race_list_page.date = date
      race_list_page.course_name = course_name
    end
    race_list_page.content = content

    race_list_page
  end

  def parse
    doc = Nokogiri::HTML.parse(@content, nil, "UTF-8")

    page_data = doc.xpath("//table[@class='scheLs']/tbody/tr").map do |tr|
      race_info = {}

      if not tr.at_xpath("td/p[@class='scheRNo']").nil?
        tr.at_xpath("td/p[@class='scheRNo']").text.match(/^[0-9]+R$/) do |race_number|
          race_info[:race_number] = race_number[0].to_i
        end
      end

      if not tr.at_xpath("td/span[@class='fntSS']").nil?
        tr.at_xpath("td/span[@class='fntSS']").text.match(/^([0-9]+):([0-9]+)$/) do |time|
          race_info[:start_datetime] = Time.zone.local(self.date.year, self.date.month, self.date.day, time[1].to_i, time[2].to_i, 0)
        end
      end

      if not tr.at_xpath("td[@class='wsLB']/a").nil?
        race_info[:race_name] = tr.at_xpath("td[@class='wsLB']/a").text.strip

        tr.at_xpath("td[@class='wsLB']/a").attribute("href").value.match(/^\/race\/result\/[0-9]+\/$/) do |path|
          race_info[:url] = "https://keiba.yahoo.co.jp" + path[0]
        end
      end

      if race_info[:race_number].nil?
        nil
      elsif race_info[:start_datetime].nil? || race_info[:race_name].nil? || race_info[:url].nil?
        Rails.logger.warn "RaceListPage(date=#{self.date.to_s},course_name=#{self.course_name})#parse: skip line: tr=#{tr.inspect}"
        nil
      else
        race_info
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
