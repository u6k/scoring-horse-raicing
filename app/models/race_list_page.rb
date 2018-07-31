class RaceListPage < ApplicationRecord

  validates :url, presence: true, uniqueness: true
  validates :date, presence: true
  validates :course_name, presence: true

  attr_accessor :content
  belongs_to :schedule_page

  def self.download(schedule_page, url, date, course_name)
    content = NetModule.download_with_get(url)

    race_list_page = find_by_url(url)
    if race_list_page.nil?
      race_list_page = schedule_page.race_list_pages.build(url: url, date: date, course_name: course_name)
    else
      race_list_page.date = date
      race_list_page.course_name = course_name
    end
    race_list_page.content = content

    race_list_page
  end

end
