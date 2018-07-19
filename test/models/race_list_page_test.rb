require 'test_helper'

class RaceListPageTest < ActiveSupport::TestCase

  def setup
    @bucket = NetModule.get_s3_bucket
    @bucket.objects.batch_delete!
  end

  test "download race list page" do
    # precondition
    year = 2018
    month = 7
    day = 16

    # execute 1
    race_list_page = RaceListPage.download(year, month, day)

    # postcondition 1
    assert_equal Time.zone.local(year, month, day, 0, 0, 0), race_list_page.date
    assert race_list_page.content.length > 0
    assert race_list_page.valid?

    assert_equal 0, RaceListPage.all.length

    assert_not @bucket.object("race_list/race_list.20180716.html").exists?

    # execute 2
    race_list_page.save!

    # postcondition 2
    assert_equal 1, RaceListPage.all.length
    assert race_list_page.same?(RaceListPage.all[0])

    assert @bucket.object("race_list/race_list.20180716.html").exists?
  end

  test "download race list page: invalid html" do
    # precondition
    year = 1900
    month = 1
    day = 1

    # execute 1
    race_list_page = RaceListPage.download(year, month, day)

    # postcondition 1
    assert_equal Time.zone.local(year, month, day, 0, 0, 0), race_list_page.date
    assert race_list_page.content.length > 0
    assert race_list_page.invalid?
    assert_equal "Invalid html", race_list_page.errors[:date][0]

    assert_equal 0, RaceListPage.all.length

    assert_not @bucket.object("race_list/race_list.20180716.html").exists?

    # execute 2
    assert_raise ActiveRecord::RecordInvalid, "Date Invalid html" do
      race_list_page.save!
    end

    # postcondition 2

    assert_equal 0, RaceListPage.all.length

    assert_not @bucket.object("race_list/race_list.20180716.html").exists?
  end

end
