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
    assert_nil race_list_page.id
    assert_equal Time.zone.local(year, month, day, 0, 0, 0), race_list_page.date
    assert race_list_page.content.length > 0
    assert race_list_page.valid?

    assert_equal 0, RaceListPage.all.length

    assert_not @bucket.object("race_list/race_list.20180716.html").exists?

    # execute 2
    race_list_page.save!

    # postcondition 2
    assert_equal 1, RaceListPage.all.length

    race_list_page_db = RaceListPage.all[0]
    assert race_list_page.same?(race_list_page_db)
    assert_not_nil race_list_page.id

    assert @bucket.object("race_list/race_list.20180716.html").exists?

    # execute 3
    race_list_page_2 = RaceListPage.download(year, month, day)

    # postcondition 3
    assert_not_nil race_list_page_2.id
    assert_equal Time.zone.local(year, month, day, 0, 0, 0), race_list_page_2.date
    assert race_list_page_2.content.length > 0
    assert race_list_page_2.valid?

    assert_equal 1, RaceListPage.all.length

    # execute 4
    race_list_page_2.save!

    # postcondition 4
    assert_equal 1, RaceListPage.all.length
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

  test "find all" do
    # precondition
    html1 = File.open("test/fixtures/files/race_list/race_list.20180714.html").read
    html2 = File.open("test/fixtures/files/race_list/race_list.20180715.html").read
    html3 = File.open("test/fixtures/files/race_list/race_list.20180716.html").read

    NetModule.put_s3_object(NetModule.get_s3_bucket, "race_list/race_list.20180714.html", html1)
    NetModule.put_s3_object(NetModule.get_s3_bucket, "race_list/race_list.20180715.html", html2)
    NetModule.put_s3_object(NetModule.get_s3_bucket, "race_list/race_list.20180716.html", html3)

    RaceListPage.create(date: Time.zone.local(2018, 7, 14, 0, 0, 0))
    RaceListPage.create(date: Time.zone.local(2018, 7, 15, 0, 0, 0))
    RaceListPage.create(date: Time.zone.local(2018, 7, 16, 0, 0, 0))

    # execute
    race_list_pages = RaceListPage.all.order(:date)

    # postcondition
    assert_equal 3, race_list_pages.length

    race_list_page = race_list_pages[0]
    assert_equal Time.zone.local(2018, 7, 14, 0, 0, 0), race_list_page.date
    assert_equal Digest::MD5.hexdigest(html1), Digest::MD5.hexdigest(race_list_page.content)

    race_list_page = race_list_pages[1]
    assert_equal Time.zone.local(2018, 7, 15, 0, 0, 0), race_list_page.date
    assert_equal Digest::MD5.hexdigest(html2), Digest::MD5.hexdigest(race_list_page.content)

    race_list_page = race_list_pages[2]
    assert_equal Time.zone.local(2018, 7, 16, 0, 0, 0), race_list_page.date
    assert_equal Digest::MD5.hexdigest(html3), Digest::MD5.hexdigest(race_list_page.content)
  end

  test "find by date" do
    # precondition
    html1 = File.open("test/fixtures/files/race_list/race_list.20180714.html").read
    html2 = File.open("test/fixtures/files/race_list/race_list.20180715.html").read
    html3 = File.open("test/fixtures/files/race_list/race_list.20180716.html").read

    NetModule.put_s3_object(NetModule.get_s3_bucket, "race_list/race_list.20180714.html", html1)
    NetModule.put_s3_object(NetModule.get_s3_bucket, "race_list/race_list.20180715.html", html2)
    NetModule.put_s3_object(NetModule.get_s3_bucket, "race_list/race_list.20180716.html", html3)

    RaceListPage.create(date: Time.zone.local(2018, 7, 14, 0, 0, 0))
    RaceListPage.create(date: Time.zone.local(2018, 7, 15, 0, 0, 0))
    RaceListPage.create(date: Time.zone.local(2018, 7, 16, 0, 0, 0))

    # execute
    race_list_page = RaceListPage.find_by_date(2018, 7, 15)

    # postcondition
    assert_equal Time.zone.local(2018, 7, 15, 0, 0, 0), race_list_page.date
    assert_equal Digest::MD5.hexdigest(html2), Digest::MD5.hexdigest(race_list_page.content)
  end

  test "find by date: not found" do
    # precondition
    html1 = File.open("test/fixtures/files/race_list/race_list.20180714.html").read
    html2 = File.open("test/fixtures/files/race_list/race_list.20180715.html").read
    html3 = File.open("test/fixtures/files/race_list/race_list.20180716.html").read

    NetModule.put_s3_object(NetModule.get_s3_bucket, "race_list/race_list.20180714.html", html1)
    NetModule.put_s3_object(NetModule.get_s3_bucket, "race_list/race_list.20180715.html", html2)
    NetModule.put_s3_object(NetModule.get_s3_bucket, "race_list/race_list.20180716.html", html3)

    RaceListPage.create(date: Time.zone.local(2018, 7, 14, 0, 0, 0))
    RaceListPage.create(date: Time.zone.local(2018, 7, 15, 0, 0, 0))
    RaceListPage.create(date: Time.zone.local(2018, 7, 16, 0, 0, 0))

    # execute
    race_list_page = RaceListPage.find_by_date(1900, 1, 1)

    # postcondition
    assert_nil race_list_page
  end

end
