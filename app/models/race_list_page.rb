require "digest/md5"

class RaceListPage < ApplicationRecord

  validates :date, presence: true, uniqueness: true
  validate :_validate

  attr_accessor :content

  before_save :_put_html
  after_initialize :_get_html

  def self.download(year, month, day)
    date = Time.zone.local(year, month, day, 0, 0, 0)

    url = "https://www.oddspark.com/keiba/KaisaiRaceList.do?raceDy=#{date.strftime('%Y%m%d')}"

    content = NetModule.download_with_get(url)

    _initialize(date, content)
  end

  def same?(obj)
    if not obj.instance_of?(RaceListPage)
      false
    elsif self.date != obj.date \
      || Digest::MD5.hexdigest(@content) != Digest::MD5.hexdigest(obj.content)
      false
    else
      true
    end
  end

  private

  def self._initialize(date, content)
    race_list_page = RaceListPage.new(date: date)
    race_list_page.content = content

    race_list_page
  end

  def _validate
    doc = Nokogiri::HTML.parse(@content, nil, "UTF-8")

    races = doc.xpath("//div[@id='raceToday']/div")

    if races.length == 0
      errors.add(:date, "Invalid html")
    end
  end

  def _build_file_path
    "race_list/race_list.#{self.date.strftime('%Y%m%d')}.html"
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
