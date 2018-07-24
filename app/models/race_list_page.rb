class RaceListPage < ApplicationRecord

  validates :course_name, presence: true
  validates :url, presence: true
  validate :_validate

  belongs_to :course_list_page
  has_many :entry_list_pages
  has_one :refund_list_page
  attr_accessor :content

  before_save :_put_html
  after_initialize :_get_html

  def self.download(course_list_page, course_name, timezone, url)
    content = NetModule.download_with_get(url)

    race_list_page = find_by_url(url)
    if race_list_page.nil?
      race_list_page = course_list_page.race_list_pages.build(course_name: course_name, timezone: timezone, url: url)
      race_list_page.content = content
    else
      race_list_page.course_name = course_name
      race_list_page.timezone = timezone
      race_list_page.url = url
      race_list_page.content = content
    end

    race_list_page
  end

  def same?(obj)
    if not obj.instance_of?(RaceListPage)
      false
    elsif self.course_name != obj.course_name \
      || self.timezone != obj.timezone \
      || self.url != obj.url \
      || Digest::MD5.hexdigest(@content) != Digest::MD5.hexdigest(obj.content) \
      || (not self.course_list_page.same?(obj.course_list_page))
      false
    else
      true
    end
  end

  def download_entry_list_pages
    entry_list_pages = _parse_entries.map do |entry|
      EntryListPage.download(self, entry[:race_number], entry[:race_name], entry[:url])
    end
  end

  def download_refund_list_page
    refund = _parse_refund
    refund_list_page = RefundListPage.download(self, refund[:url])
  end

  private

  def _validate
    entries = _parse_entries
    refund = _parse_refund

    if entries.length == 0 || refund.nil?
      errors.add(:course_name, "Invalid html")
    end
  end

  def _parse_entries
    doc = Nokogiri::HTML.parse(@content, nil, "UTF-8")

    entries = doc.xpath("//div[@class='section clearfix']/div/div/strong/a").map do |race|
      {
        race_number: race.text.strip.split("\xc2\xa0")[0],
        race_name: race.text.strip.split("\xc2\xa0")[2],
        url: "https://www.oddspark.com" + race.attribute("href").value
      }
    end
  end

  def _parse_refund
    doc = Nokogiri::HTML.parse(@content, nil, "UTF-8")

    refund = doc.xpath("//div[@id='RCtab']/ul/li[5]/a").map do |refund_link|
      {
        url: "https://www.oddspark.com" + refund_link.attribute("href").value
      }
    end

    refund.empty? ? nil : refund[0]
  end

  def _build_file_path
    "race_list/#{self.course_list_page.date.strftime('%Y%m%d')}/race_list.#{self.course_name}.html"
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
