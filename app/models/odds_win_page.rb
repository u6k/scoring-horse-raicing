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
