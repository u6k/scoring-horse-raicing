class RaceListPage < ApplicationRecord

  validates :date, presence: true, uniqueness: true

  attr_accessor :content

  def self.download(year, month, day)
    date = Time.zone.local(year, month, day, 0, 0, 0)

    url = "https://www.oddspark.com/keiba/KaisaiRaceList.do?raceDy=#{date.strftime('yyyyMMdd')}"

    content = NetModule.download_with_get(url)

    _initialize(date, content)
  end

  private

  def self._initialize(date, content)
    race_list_page = RaceListPage.new(date: date)
    race_list_page.content = content

    race_list_page
  end

end
