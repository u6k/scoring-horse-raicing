class RaceListPage < ApplicationRecord

  validates :course_name, presence: true
  validates :url, presence: true
  validate :_validate

  belongs_to :course_list_page
  attr_accessor :content

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

  private

  def _validate
    # TODO
  end

end
