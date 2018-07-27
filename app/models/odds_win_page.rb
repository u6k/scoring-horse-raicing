class OddsWinPage < ApplicationRecord

  validates :url, presence: true, uniqueness: true
  validate :_validate

  belongs_to :entry_list_page
  attr_accessor :content

  def self.download(entry_list_page, url, content = nil)
    if content.nil?
      content = NetModule.download_with_get(url)
    end

    odds_win_page = find_by_url(url)
    if odds_win_page.nil?
      odds_win_page = entry_list_page.build_odds_win_page(url: url)
    else
      odds_win_page.url = url
    end
    odds_win_page.content = content

    odds_win_page
  end

  def same?(obj)
    if not obj.instance_of?(OddsWinPage)
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

    page_data = { win: [], place: [] }

    doc.xpath("//table[@summary='単勝・複勝']/tr[contains(@class, 'bg-')]").each do |tr|
      if tr.xpath("td").length == 5
        horse_number_index = 2
      else
        horse_number_index = 1
      end

      odds_win = {
        horse_number: tr.xpath("td[#{horse_number_index}]").text.strip.to_i,
        horse_name: tr.xpath("td[#{horse_number_index + 1}]/a").text,
        url: "https://www.oddspark.com" + tr.xpath("td[#{horse_number_index + 1}]/a").attribute("href").value,
        odds: tr.xpath("td[#{horse_number_index + 2}]/span").text.to_d,
      }

      odds_place = {
        horse_number: odds_win[:horse_number],
        horse_name: odds_win[:horse_name],
        url: odds_win[:url],
        odds: [tr.xpath("td[#{horse_number_index + 3}]/span[1]").text.to_d, tr.xpath("td[#{horse_number_index + 3}]/span[2]").text.to_d],
      }

      page_data[:win] << odds_win
      page_data[:place] << odds_place
    end

    doc.xpath("//table[@summary='枠複']").each do |table|
      page_data[:bracket_quinella] = [
        { bracket_number: [1, 2], odds: table.xpath("tr[3]/td[2]/span").text.to_d },
        { bracket_number: [1, 3], odds: table.xpath("tr[4]/td[2]/span").text.to_d },
        { bracket_number: [1, 4], odds: table.xpath("tr[5]/td[2]/span").text.to_d },
        { bracket_number: [1, 5], odds: table.xpath("tr[6]/td[2]/span").text.to_d },
        { bracket_number: [1, 6], odds: table.xpath("tr[7]/td[2]/span").text.to_d },
        { bracket_number: [1, 7], odds: table.xpath("tr[8]/td[2]/span").text.to_d },
        { bracket_number: [1, 8], odds: table.xpath("tr[9]/td[2]/span").text.to_d },
        { bracket_number: [2, 3], odds: table.xpath("tr[3]/td[4]/span").text.to_d },
        { bracket_number: [2, 4], odds: table.xpath("tr[4]/td[4]/span").text.to_d },
        { bracket_number: [2, 5], odds: table.xpath("tr[5]/td[4]/span").text.to_d },
        { bracket_number: [2, 6], odds: table.xpath("tr[6]/td[4]/span").text.to_d },
        { bracket_number: [2, 7], odds: table.xpath("tr[7]/td[4]/span").text.to_d },
        { bracket_number: [2, 8], odds: table.xpath("tr[8]/td[4]/span").text.to_d },
        { bracket_number: [3, 4], odds: table.xpath("tr[3]/td[6]/span").text.to_d },
        { bracket_number: [3, 5], odds: table.xpath("tr[4]/td[6]/span").text.to_d },
        { bracket_number: [3, 6], odds: table.xpath("tr[5]/td[6]/span").text.to_d },
        { bracket_number: [3, 7], odds: table.xpath("tr[6]/td[6]/span").text.to_d },
        { bracket_number: [3, 8], odds: table.xpath("tr[7]/td[6]/span").text.to_d },
        { bracket_number: [4, 5], odds: table.xpath("tr[3]/td[8]/span").text.to_d },
        { bracket_number: [4, 6], odds: table.xpath("tr[4]/td[8]/span").text.to_d },
        { bracket_number: [4, 7], odds: table.xpath("tr[5]/td[8]/span").text.to_d },
        { bracket_number: [4, 8], odds: table.xpath("tr[6]/td[8]/span").text.to_d },
        { bracket_number: [5, 6], odds: table.xpath("tr[10]/td[6]/span").text.to_d },
        { bracket_number: [5, 7], odds: table.xpath("tr[11]/td[7]/span").text.to_d },
        { bracket_number: [5, 8], odds: table.xpath("tr[12]/td[8]/span").text.to_d },
        { bracket_number: [6, 7], odds: table.xpath("tr[11]/td[5]/span").text.to_d },
        { bracket_number: [6, 8], odds: table.xpath("tr[12]/td[6]/span").text.to_d },
        { bracket_number: [7, 8], odds: table.xpath("tr[12]/td[4]/span").text.to_d },
        { bracket_number: [8, 8], odds: table.xpath("tr[12]/td[2]/span").text.to_d },
      ]
    end

    page_data
  end

  private

  def _validate
    nil # TODO
  end

  def _build_file_path
    "race_list/#{self.entry_list_page.rase_list_page.course_list_page.date.strftime('%Y%m%d')}/#{self.entry_list_page.race_list_page.course_name}/#{self.entry_list_page.race_number}/odds_win.html"
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
