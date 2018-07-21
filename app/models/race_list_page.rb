class RaceListPage < ApplicationRecord

  validates :course_name, presence: true
  validates :timezone, presence: true
  validates :url, presence: true
  validate :_validate

  attr_accessor :content

  def self.download(course_name, timezone, url)
    content = NetModule.download_with_get(url)

    race_list_page = find_by_url(url)
    if race_list_page.nil?
      _initialize(course_name, timezone, url, content)
    else
      race_list_page.course_name = course_name
      race_list_page.timezone = timezone
      race_list_page.url = url
      race_list_page.content = content

      race_list_page
    end
  end

  private

  def self._initialize(course_name, timezone, url, content)
    race_list_page = RaceListPage.new(course_name: course_name, timezone: timezone, url: url)
    race_list_page.content = content

    race_list_page
  end

  def _validate
    # TODO
  end

end
