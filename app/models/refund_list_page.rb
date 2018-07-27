class RefundListPage < ApplicationRecord

  validates :url, presence: true, uniqueness: true
  validate :_validate

  belongs_to :race_list_page
  attr_accessor :content

  before_save :_put_html
  after_initialize :_get_html

  def self.download(race_list_page, url, content = nil)
    if content.nil?
      content = NetModule.download_with_get(url)
    end

    refund_list_page = find_by_url(url)
    if refund_list_page.nil?
      refund_list_page = race_list_page.build_refund_list_page(url: url)
      refund_list_page.content = content
    else
      refund_list_page.content = content
    end

    refund_list_page
  end

  def same?(obj)
    if not obj.instance_of?(RefundListPage)
      false
    elsif self.url != obj.url \
      || (not self.race_list_page.same?(obj.race_list_page)) \
      || self.parse != obj.parse
      false
    else
      true
    end
  end

  def parse
    doc = Nokogiri::HTML.parse(@content, nil, "UTF-8")

    race_infos = doc.xpath("//div[@class='RCres1']/ul").map do |race_info_node|
      {
        race_number: race_info_node.xpath("li[1]/span").text.match(/([0-9]+)R/)[1].to_i,
        race_name: race_info_node.xpath("li[2]/h3/a").text.strip,
        url: "https://www.oddspark.com" + race_info_node.xpath("li[2]/h3/a").attribute("href").value
      }
    end

    refund_records = doc.xpath("//table[contains(@class, 'minipay')]/tr").map do |minipay_record_node|
      {
        bet_type: minipay_record_node.xpath("th").text,
        horse_number: minipay_record_node.xpath("td[1]").text,
        money: minipay_record_node.xpath("td[2]").text.gsub(/[,円]/, "").to_i
      }
    end

    race_info_index = 0
    refund = {}
    refund_records.each do |refund_record|
      if refund_record[:bet_type] == "単勝" && refund_record[:horse_number].match(/^[0-9]+$/) && refund_record[:money].integer?
        refund[:win] = { horse_number: refund_record[:horse_number], money: refund_record[:money] }
      elsif refund_record[:bet_type] == "複勝" && refund_record[:horse_number].match(/^[0-9]+$/) && refund_record[:money].integer?
        refund[:place] = [
          { horse_number: refund_record[:horse_number], money: refund_record[:money] }
        ]
      elsif refund_record[:bet_type] == "" && refund_record[:horse_number].match(/^[0-9]+$/) && refund_record[:money].integer?
        refund[:place] << { horse_number: refund_record[:horse_number], money: refund_record[:money] }
      elsif refund_record[:bet_type] == "枠連" && refund_record[:horse_number] == "発売なし"
        #
      elsif refund_record[:bet_type] == "枠連" && refund_record[:horse_number].match(/^[0-9]+\-[0-9]+$/) && refund_record[:money].integer?
        refund[:bracket_quinella] = { horse_number: refund_record[:horse_number], money: refund_record[:money] }
      elsif refund_record[:bet_type] == "馬連" && refund_record[:horse_number].match(/^[0-9]+\-[0-9]+$/) && refund_record[:money].integer?
        refund[:quinella] = { horse_number: refund_record[:horse_number], money: refund_record[:money] }
      elsif refund_record[:bet_type] == "馬単" && refund_record[:horse_number].match(/^[0-9]+\-[0-9]+$/) && refund_record[:money].integer?
        refund[:exacta] = { horse_number: refund_record[:horse_number], money: refund_record[:money] }
      elsif refund_record[:bet_type] == "ワイド" && refund_record[:horse_number].match(/^[0-9]+\-[0-9]+$/) && refund_record[:money].integer?
        refund[:quinella_place] = [
          { horse_number: refund_record[:horse_number], money: refund_record[:money] }
        ]
      elsif refund_record[:bet_type] == "" && refund_record[:horse_number].match(/^[0-9]+\-[0-9]+$/) && refund_record[:money].integer?
        refund[:quinella_place] << { horse_number: refund_record[:horse_number], money: refund_record[:money] }
      elsif refund_record[:bet_type] == "3連複" && refund_record[:horse_number].match(/^[0-9]+\-[0-9]+\-[0-9]+$/) && refund_record[:money].integer?
        refund[:trio] = { horse_number: refund_record[:horse_number], money: refund_record[:money] }
      elsif refund_record[:bet_type] == "3連単" && refund_record[:horse_number].match(/^[0-9]+\-[0-9]+\-[0-9]+$/) && refund_record[:money].integer?
        refund[:trifecta] = { horse_number: refund_record[:horse_number], money: refund_record[:money] }
      else
        raise "Invalid html"
      end

      if (not refund[:trifecta].nil?)
        race_infos[race_info_index][:refund] = refund
        race_info_index += 1
        refund = {}
      end
    end

    race_infos
  end

  private

  def _validate
    race_infos = parse

    if race_infos.length == 0
      errors.add(:url, "Invalid html")
    end
  end

  def _build_file_path
    "race_list/#{self.race_list_page.course_list_page.date.strftime('%Y%m%d')}/#{self.race_list_page.course_name}/refund_list.html"
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
