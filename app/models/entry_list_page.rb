class EntryListPage < ApplicationRecord

  belongs_to :race_list_page

  def self.download(race_list_page, race_number, race_name, url)
    race_list_page.entry_list_pages.build # TODO
  end

end
