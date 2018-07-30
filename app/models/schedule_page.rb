class SchedulePage < ApplicationRecord

  validates :url, presence: true, uniqueness: true
  validates :datetime, presence: true

  attr_accessor :content

  def self.download(year, month)
    datetime = Time.zone.local(year, month, 1, 0, 0, 0)
    url = "https://keiba.yahoo.co.jp/schedule/list/#{datetime.year}/?month=#{datetime.month}"

    content = NetModule.download_with_get(url)

    schedule_page = find_by_url(url)
    if schedule_page.nil?
      schedule_page = SchedulePage.new(url: url, datetime: datetime)
    else
      schedule_page.datetime = datetime
    end
    schedule_page.content = content

    schedule_page
  end

end
