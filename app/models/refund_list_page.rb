class RefundListPage < ApplicationRecord

  validates :url, presence: true, uniqueness: true

  belongs_to :race_list_page
  attr_accessor :content

  before_save :_put_html
  after_initialize :_get_html

  def self.download(race_list_page, url)
    content = NetModule.download_with_get(url)

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
    true # FIXME
  end

  private

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
