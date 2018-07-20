require "digest/md5"

class CourseListPage < ApplicationRecord

  validates :date, presence: true, uniqueness: true
  validates :url, presence: true
  validate :_validate

  attr_accessor :content

  before_save :_put_html
  after_initialize :_get_html

  def self.download(year, month, day)
    date = Time.zone.local(year, month, day, 0, 0, 0)

    url = "https://www.oddspark.com/keiba/KaisaiRaceList.do?raceDy=#{date.strftime('%Y%m%d')}"

    content = NetModule.download_with_get(url)

    course_list_page = find_by_date(year, month, day)
    if course_list_page.nil?
      _initialize(date, url, content)
    else
      course_list_page.content = content
      course_list_page
    end
  end

  def self.find_by_date(year, month, day)
    date = Time.zone.local(year, month, day, 0, 0, 0)

    course_list_pages = CourseListPage.where(date: date)

    if course_list_pages.empty?
      nil
    else
      course_list_pages[0]
    end
  end

  def same?(obj)
    if not obj.instance_of?(CourseListPage)
      false
    elsif self.date != obj.date \
      || self.url != obj.url \
      || Digest::MD5.hexdigest(@content) != Digest::MD5.hexdigest(obj.content)
      false
    else
      true
    end
  end

  private

  def self._initialize(date, url, content)
    course_list_page = CourseListPage.new(date: date, url: url)
    course_list_page.content = content

    course_list_page
  end

  def _validate
    doc = Nokogiri::HTML.parse(@content, nil, "UTF-8")

    races = doc.xpath("//div[@id='raceToday']/div")

    if races.length == 0
      errors.add(:date, "Invalid html")
    end
  end

  def _build_file_path
    "course_list/course_list.#{self.date.strftime('%Y%m%d')}.html"
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
