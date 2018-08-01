class ResultPage < ApplicationRecord

  validates :url, presence: true, uniqueness: true
  validates :race_number, presence: true
  validates :race_name, presence: true
  validate :_validate

  attr_accessor :content
  belongs_to :race_list_page

  before_save :_put_html
  after_initialize :_get_html

  def self.download(race_list_page, url, race_number, start_datetime, race_name, content = nil)
    if content.nil?
      content = NetModule.download_with_get(url)
    end

    result_page = find_by_url(url)
    if result_page.nil?
      result_page = race_list_page.result_pages.build(url: url, race_number: race_number, start_datetime: start_datetime, race_name: race_name)
    else
      result_page.race_number = race_number
      result_page.start_datetime = start_datetime
      result_page.race_name = race_name
    end
    result_page.content = content

    result_page
  end

  def parse
    doc = Nokogiri::HTML.parse(@content, nil, "UTF-8")

    menu = {}
    entries_link = doc.at_xpath("//div[@id='raceNavi']/ul/li/a[contains(text(), '出馬表')]")
    if not entries_link.nil?
      entries_link.attribute("href").value.match(/^\/race\/denma\/[0-9]+\/$/) do |path|
        menu[:entries] = "https://keiba.yahoo.co.jp" + path[0]
      end
    end
    odds_link = doc.at_xpath("//div[@id='raceNavi']/ul/li/a[contains(text(), 'オッズ')]")
    if not odds_link.nil?
      odds_link.attribute("href").value.match(/^\/odds\/tfw\/[0-9]+\/$/) do |path|
        menu[:odds_win] = "https://keiba.yahoo.co.jp" + path[0]
      end
    end

    result = doc.xpath("//table[@id='raceScore']/tbody/tr").map do |tr|
      finish_info = {}

      tr.at_xpath("td[1]").text.strip.match(/^[0-9]+$/) do |order_of_finish|
        finish_info[:order_of_finish] = order_of_finish[0].to_i
      end

      tr.at_xpath("td[2]/span").text.strip.match(/^[0-9]+$/) do |bracket_number|
        finish_info[:bracket_number] = bracket_number[0].to_i
      end

      tr.at_xpath("td[3]").text.strip.match(/^[0-9]+$/) do |horse_number|
        finish_info[:horse_number] = horse_number[0].to_i
      end

      if not tr.at_xpath("td[4]/a").nil?
        tr.at_xpath("td[4]/a").attribute("href").value.match(/^\/directory\/horse\/[0-9]+\/$/) do |horse_url|
          finish_info[:horse_url] = "https://keiba.yahoo.co.jp" + horse_url[0]
        end

        finish_info[:horse_name] = tr.at_xpath("td[4]/a").text
      end

      tr.at_xpath("td[5]/text()").text.strip.match(/^([0-9]+)\.([0-9]+)\.([0-9]+)$/) do |finish_time|
        finish_info[:finish_time] = finish_time[1].to_d * 60 + finish_time[2].to_d + finish_time[3].to_d / 10
      end

      if finish_info[:bracket_number].nil? \
        || finish_info[:horse_number].nil? \
        || finish_info[:horse_url].nil? \
        || finish_info[:horse_name].nil?
        Rails.logger.warn "ResultPage(race_number=#{self.race_number},start_datetime=#{self.start_datetime})#parse: skip line: tr=#{tr.inspect}"
        nil
      else
        finish_info
      end
    end

    result.compact!

    page_data = {
      menu: menu,
      result: result,
    }

    if page_data[:result].empty?
      nil
    else
      page_data
    end
  end

  def same?(obj)
    if not obj.instance_of?(ResultPage)
      false
    elsif self.url != obj.url \
      || self.race_number != obj.race_number \
      || self.start_datetime != obj.start_datetime \
      || self.race_name != obj.race_name \
      || (not self.race_list_page.same?(obj.race_list_page)) \
      || self.parse != obj.parse
      false
    else
      true
    end
  end

  private

  def _validate
    page_data = parse

    if page_data.nil?
      errors.add(:url, "Invalid html")
    end
  end

  def _build_file_path
    "html/#{race_list_page.schedule_page.date.strftime('%Y%m')}/#{race_list_page.date.strftime('%Y%m%d')}/#{race_list_page.course_name}/#{race_number}/result.html"
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
