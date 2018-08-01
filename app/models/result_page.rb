class ResultPage < ApplicationRecord

  attr_accessor :content
  belongs_to :race_list_page

  def self.download(race_list_page, url, race_number, start_datetime, race_name)
    content = NetModule.download_with_get(url)

    result_page = find_by_url(url)
    if result_page.nil?
      result_page = race_list_page.result_pages.build(url: url, race_number: race_number, start_datetime: start_datetime, race_name: race_name)
    else
      result_page.race_number = race_number
      result_page.start_datetime = start_datetime
      result_page.race_name = race_name
    end
    result_page.content = content

    result_page
  end

end
