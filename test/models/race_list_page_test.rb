require 'test_helper'

class RaceListPageTest < ActiveSupport::TestCase

  test "download race list page" do
    # precondition
    year = 2018
    month = 7
    day = 16

    # execute
    race_list_page = RaceListPage.download(year, month, day)

    # postcondition
    assert_equal Time.zone.local(year, month, day, 0, 0, 0), race_list_page.date
    assert race_list_page.content.length > 0
  end

end
