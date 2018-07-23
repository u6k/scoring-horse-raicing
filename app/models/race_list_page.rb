class RaceListPage < ApplicationRecord

  validates :course_name, presence: true
  validates :url, presence: true
  validate :_validate

  belongs_to :course_list_page
  attr_accessor :content

  before_save :_put_html
  after_initialize :_get_html

  def self.download(course_list_page, course_name, timezone, url)
    content = NetModule.download_with_get(url)

    race_list_page = find_by_url(url)
    if race_list_page.nil?
      race_list_page = course_list_page.race_list_pages.new(course_name: course_name, timezone: timezone, url: url)
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

  private

  def _validate
    true # TODO
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
