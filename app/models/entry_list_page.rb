class EntryListPage < ApplicationRecord

  validates :url, presence: true, uniqueness: true
  validates :race_number, presence: true
  validates :race_name, presence: true
  validate :_validate

  belongs_to :race_list_page
  has_one :odds_win_page
  attr_accessor :content

  before_save :_put_html
  after_initialize :_get_html

  def self.download(race_list_page, race_number, race_name, url)
    content = NetModule.download_with_get(url)

    entry_list_page = find_by_url(url)
    if entry_list_page.nil?
      entry_list_page = race_list_page.entry_list_pages.build(race_number: race_number, race_name: race_name, url: url)
      entry_list_page.content = content
    else
      entry_list_page.race_number = race_number
      entry_list_page.race_name = race_name
      entry_list_page.url = url
      entry_list_page.content = content
    end

    entry_list_page
  end

  def same?(obj)
    if not obj.instance_of?(EntryListPage)
      false
    elsif self.race_number != obj.race_number \
      || self.race_name != obj.race_name \
      || self.url != obj.url \
      || (not self.race_list_page.same?(obj.race_list_page)) \
      || self.parse != obj.parse
      false
    else
      true
    end
  end

  def parse
    doc = Nokogiri::HTML.parse(@content, nil, "UTF-8")

    race_data = doc.xpath("//div[@id='RCdata2']/ul")

    race_info = {
      place: race_data.xpath("li[@class='RCnum']").text,
      distance: race_data.xpath("li[@class='RCdst']").text,
      start_time: race_data.xpath("li[@class='RCstm']").text,
      weather: race_data.xpath("li[@class='RCwthr']").text,
      water: race_data.xpath("li[@class='RCwatr']/span[@class='baba']").text
    }

    horses = doc.xpath("//div[@class='section clearfix']/table/tr[position()>2]").map do |horse_data|
      if not horse_data.at_xpath("td[5]/a").nil?
        {
          horse: {
            number: horse_data.xpath("td[4]").text.to_i,
            name: horse_data.xpath("td[5]/a/strong").text,
            url: "https://www.oddspark.com" + horse_data.xpath("td[5]/a").attribute("href").value,
            weight: horse_data.xpath("td[8]").text.match(/([0-9]+)[\n\t]*([0-9\-\+]+)/m).nil? ? nil : horse_data.xpath("td[8]").text.match(/([0-9]+)[\n\t]*([0-9\-\+]+)/m)[1].to_i,
            weight_diff: horse_data.xpath("td[8]").text.match(/([0-9]+)[\n\t]*([0-9\-\+]+)/m).nil? ? nil : horse_data.xpath("td[8]").text.match(/([0-9]+)[\n\t]*([0-9\-\+]+)/m)[2].to_i,
          },
          jockey: {
            name: horse_data.xpath("td[6]/a[1]").text,
            url: "https://www.oddspark.com" + horse_data.xpath("td[6]/a[1]").attribute("href").value,
          },
          trainer: {
            name: horse_data.xpath("td[6]/a[2]").text,
            url: "https://www.oddspark.com" + horse_data.xpath("td[6]/a[2]").attribute("href").value,
          }
        }
      else
        {
          horse: {
            number: horse_data.xpath("td[2]").text.to_i,
            name: horse_data.xpath("td[3]/a/strong").text,
            url: "https://www.oddspark.com" + horse_data.xpath("td[3]/a").attribute("href").value,
            weight: horse_data.xpath("td[6]").text.match(/([0-9]+)[\n\t]*([0-9\-\+]+)/m).nil? ? nil : horse_data.xpath("td[6]").text.match(/([0-9]+)[\n\t]*([0-9\-\+]+)/m)[1].to_i,
            weight_diff: horse_data.xpath("td[6]").text.match(/([0-9]+)[\n\t]*([0-9\-\+]+)/m).nil? ? nil : horse_data.xpath("td[6]").text.match(/([0-9]+)[\n\t]*([0-9\-\+]+)/m)[2].to_i,
          },
          jockey: {
            name: horse_data.xpath("td[4]/a[1]").text,
            url: "https://www.oddspark.com" + horse_data.xpath("td[4]/a[1]").attribute("href").value,
          },
          trainer: {
            name: horse_data.xpath("td[4]/a[2]").text,
            url: "https://www.oddspark.com" + horse_data.xpath("td[4]/a[2]").attribute("href").value,
          }
        }
      end
    end

    odds = {
      url: doc.at_xpath("//div[@id='RCtab']/ul/li[3]/a").nil? ? "" : "https://www.oddspark.com" + doc.xpath("//div[@id='RCtab']/ul/li[3]/a").attribute("href").value
    }

    result = {
      url: doc.at_xpath("//div[@id='RCtab']/ul/li[4]/a").nil? ? "" : "https://www.oddspark.com" + doc.xpath("//div[@id='RCtab']/ul/li[4]/a").attribute("href").value
    }

    {
      race_info: race_info,
      horses: horses,
      odds: odds,
      result: result,
    }
  end

  def download_odds_win_page
    page_data = parse

    OddsWinPage.download(self, page_data[:odds][:url])
  end

  private

  def _validate
    page_data = parse

    if page_data[:race_info][:place].empty? \
      || page_data[:race_info][:distance].empty? \
      || page_data[:race_info][:start_time].empty? \
      || page_data[:race_info][:weather].empty? \
      || page_data[:race_info][:water].empty?
      errors.add(:url, "Invalid html")
    end

    page_data[:horses].each do |horse|
      if horse[:horse][:number].nil? \
        || horse[:horse][:name].empty? \
        || horse[:horse][:url].empty? \
        || horse[:jockey][:name].empty? \
        || horse[:jockey][:url].empty? \
        || horse[:trainer][:name].empty? \
        || horse[:trainer][:url].empty?
        errors.add(:url, "Invalid html")
      end
    end

    if page_data[:odds][:url].empty? \
      || page_data[:result][:url].empty?
      errors.add(:url, "Invalid html")
    end
  end

  def _build_file_path
    "race_list/#{self.race_list_page.course_list_page.date.strftime('%Y%m%d')}/#{self.race_list_page.course_name}/#{race_number}/entry_list.html"
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
