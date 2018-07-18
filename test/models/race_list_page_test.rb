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
    assert race_list_page.valid?
  end

  test "download race list page: invalid html" do
    # precondition
    year = 1900
    month = 1
    day = 1

    # execute
    race_list_page = RaceListPage.download(year, month, day)

    # postcondition
    assert_equal Time.zone.local(year, month, day, 0, 0, 0), race_list_page.date
    assert race_list_page.content.length > 0
    assert race_list_page.invalid?
    assert_equal "Invalid html", race_list_page.errors[:date][0]
  end

end
