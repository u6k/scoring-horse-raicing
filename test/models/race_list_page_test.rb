require 'test_helper'

class RaceListPageTest < ActiveSupport::TestCase

  test "download race list page" do
    # execute
    race_list_page = RaceListPage.download(2018, 7, 16)

    # postcondition
    assert_equal Time.zone.local(2018, 7, 16, 0, 0, 0), race_list_page.date
    assert race_list_page.content.length > 0
  end

  test "download race list page: case invalid date" do
    # execute
    assert_raise RuntimeError, "race_list_page not found. date:2018-02-31" do
      RaceListPage.download(2018, 2, 31)
    end
  end

end
