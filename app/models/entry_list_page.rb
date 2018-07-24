class EntryListPage < ApplicationRecord

  validates :race_number, presence: true
  validates :race_name, presence: true
  validates :url, presence: true
  validate :_validate

  belongs_to :race_list_page
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
      || (not self.race_list_page.same?(obj.race_list_page))
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
