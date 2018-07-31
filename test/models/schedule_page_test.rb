require 'test_helper'

class SchedulePageTest < ActiveSupport::TestCase

  def setup
    @bucket = NetModule.get_s3_bucket
    @bucket.objects.batch_delete!
  end

  test "download" do
    # execute
    schedule_page = SchedulePage.download(2018, 6)

    # postcondition
    assert_equal 0, SchedulePage.all.length
    
    assert_equal "https://keiba.yahoo.co.jp/schedule/list/2018/?month=6", schedule_page.url
    assert_equal Time.zone.local(2018, 6, 1), schedule_page.datetime
    assert schedule_page.content.length > 0
    assert schedule_page.valid?
    assert_not @bucket.object("html/201806/schedule.html").exists?
  end

  test "download: case current month" do
    # precondition
    current_time = Time.zone.now

    # execute
    schedule_page = SchedulePage.download(current_time.year, current_time.month)

    # postcondition
    assert_equal 0, SchedulePage.all.length

    assert_equal "https://keiba.yahoo.co.jp/schedule/list/#{current_time.year}/?month=#{current_time.month}", schedule_page.url
    assert_equal Time.zone.local(current_time.year, current_time.month, 1), schedule_page.datetime
    assert schedule_page.content.length > 0
    assert schedule_page.valid?
    assert_not @bucket.object("html/#{current_time.strftime('%Y%m')}/schedule.html").exists?
  end

  test "download: case link nothing" do
    # execute
    html = File.open("test/fixtures/files/schedule.201808.html").read
    schedule_page = SchedulePage.download(2018, 8, html)

    # postcondition
    assert_equal 0, SchedulePage.all.length
    
    assert_equal "https://keiba.yahoo.co.jp/schedule/list/2018/?month=8", schedule_page.url
    assert_equal Time.zone.local(2018, 8, 1), schedule_page.datetime
    assert schedule_page.content.length > 0
    assert schedule_page.valid?
    assert_not @bucket.object("html/201808/schedule.html").exists?
  end

  test "download: case content not found" do
    # execute
    schedule_page = SchedulePage.download(1900, 1)

    # postcondition
    assert_equal 0, SchedulePage.all.length
    
    assert_equal "https://keiba.yahoo.co.jp/schedule/list/1900/?month=1", schedule_page.url
    assert_equal Time.zone.local(1900, 1, 1), schedule_page.datetime
    assert_nil schedule_page.content
    assert schedule_page.invalid?
    assert_not @bucket.object("html/190001/schedule.html").exists?
  end

  test "parse" do
    # precondition
    html = File.open("test/fixtures/files/schedule.201806.html")
    schedule_page = SchedulePage.download(2018, 6, html)

    # execute
    page_data = schedule_page.parse

    # postcondition
    expected_data = [
      {
        date: Time.zone.local(2018, 6, 2),
        url: "https://keiba.yahoo.co.jp/race/list/18050301/",
        course_name: "東京"
      },
      {
        date: Time.zone.local(2018, 6, 2),
        url: "https://keiba.yahoo.co.jp/race/list/18090301/",
        course_name: "阪神"
      },
      {
        date: Time.zone.local(2018, 6, 3),
        url: "https://keiba.yahoo.co.jp/race/list/18050302/",
        course_name: "東京"
      },
      {
        date: Time.zone.local(2018, 6, 3),
        url: "https://keiba.yahoo.co.jp/race/list/18090302/",
        course_name: "阪神"
      },
      {
        date: Time.zone.local(2018, 6, 9),
        url: "https://keiba.yahoo.co.jp/race/list/18050303/",
        course_name: "東京"
      },
      {
        date: Time.zone.local(2018, 6, 9),
        url: "https://keiba.yahoo.co.jp/race/list/18090303/",
        course_name: "阪神"
      },
      {
        date: Time.zone.local(2018, 6, 10),
        url: "https://keiba.yahoo.co.jp/race/list/18050304/",
        course_name: "東京"
      },
      {
        date: Time.zone.local(2018, 6, 10),
        url: "https://keiba.yahoo.co.jp/race/list/18090304/",
        course_name: "阪神"
      },
      {
        date: Time.zone.local(2018, 6, 16),
        url: "https://keiba.yahoo.co.jp/race/list/18020101/",
        course_name: "函館"
      },
      {
        date: Time.zone.local(2018, 6, 16),
        url: "https://keiba.yahoo.co.jp/race/list/18050305/",
        course_name: "東京"
      },
      {
        date: Time.zone.local(2018, 6, 16),
        url: "https://keiba.yahoo.co.jp/race/list/18090305/",
        course_name: "阪神"
      },
      {
        date: Time.zone.local(2018, 6, 17),
        url: "https://keiba.yahoo.co.jp/race/list/18020102/",
        course_name: "函館"
      },
      {
        date: Time.zone.local(2018, 6, 17),
        url: "https://keiba.yahoo.co.jp/race/list/18050306/",
        course_name: "東京"
      },
      {
        date: Time.zone.local(2018, 6, 17),
        url: "https://keiba.yahoo.co.jp/race/list/18090306/",
        course_name: "阪神"
      },
      {
        date: Time.zone.local(2018, 6, 23),
        url: "https://keiba.yahoo.co.jp/race/list/18020103/",
        course_name: "函館"
      },
      {
        date: Time.zone.local(2018, 6, 23),
        url: "https://keiba.yahoo.co.jp/race/list/18050307/",
        course_name: "東京"
      },
      {
        date: Time.zone.local(2018, 6, 23),
        url: "https://keiba.yahoo.co.jp/race/list/18090307/",
        course_name: "阪神"
      },
      {
        date: Time.zone.local(2018, 6, 24),
        url: "https://keiba.yahoo.co.jp/race/list/18020104/",
        course_name: "函館"
      },
      {
        date: Time.zone.local(2018, 6, 24),
        url: "https://keiba.yahoo.co.jp/race/list/18050308/",
        course_name: "東京"
      },
      {
        date: Time.zone.local(2018, 6, 24),
        url: "https://keiba.yahoo.co.jp/race/list/18090308/",
        course_name: "阪神"
      },
      {
        date: Time.zone.local(2018, 6, 30),
        url: "https://keiba.yahoo.co.jp/race/list/18020105/",
        course_name: "函館"
      },
      {
        date: Time.zone.local(2018, 6, 30),
        url: "https://keiba.yahoo.co.jp/race/list/18030201/",
        course_name: "福島"
      },
      {
        date: Time.zone.local(2018, 6, 30),
        url: "https://keiba.yahoo.co.jp/race/list/18070301/",
        course_name: "中京"
      },
    ]

    assert_equal page_data, expected_data
  end

  test "parse: case line skip" do
    # precondition
    html = File.open("test/fixtures/files/schedule.201808.html")
    schedule_page = SchedulePage.download(2018, 8, html)

    # execute
    page_data = schedule_page.parse

    # postcondition
    expected_data = [
      {
        date: Time.zone.local(2018, 8, 4),
        url: "https://keiba.yahoo.co.jp/race/list/18010103/",
        course_name: "札幌"
      },
      {
        date: Time.zone.local(2018, 8, 4),
        url: "https://keiba.yahoo.co.jp/race/list/18040203/",
        course_name: "新潟"
      },
      {
        date: Time.zone.local(2018, 8, 4),
        url: "https://keiba.yahoo.co.jp/race/list/18100203/",
        course_name: "小倉"
      },
      {
        date: Time.zone.local(2018, 8, 5),
        url: "https://keiba.yahoo.co.jp/race/list/18010104/",
        course_name: "札幌"
      },
      {
        date: Time.zone.local(2018, 8, 5),
        url: "https://keiba.yahoo.co.jp/race/list/18040204/",
        course_name: "新潟"
      },
      {
        date: Time.zone.local(2018, 8, 5),
        url: "https://keiba.yahoo.co.jp/race/list/18100204/",
        course_name: "小倉"
      },
    ]

    assert_equal page_data, expected_data
  end

  test "parse: case invalid html" do
    # precondition
    schedule_page = SchedulePage.download(1900, 1, "Invalid HTML")

    # execute
    page_data = schedule_page.parse

    # postcondition
    assert_nil page_data
  end

  test "save, and overwrite" do
    # execute 1
    html = File.open("test/fixtures/files/schedule.201806.html").read
    schedule_page = SchedulePage.download(2018, 6, html)

    # postcondition 1
    assert_equal 0, SchedulePage.all.length

    assert schedule_page.valid?
    assert_not @bucket.object("html/201806/schedule.html").exists?

    # execute 2
    schedule_page.save!

    # postcondition 2
    assert_equal 1, SchedulePage.all.length

    assert @bucket.object("html/201806/schedule.html").exists?

    # execute 3
    schedule_page_2 = SchedulePage.download(2018, 6, html)

    # postcondition 3
    assert_equal 1, SchedulePage.all.length

    assert schedule_page_2.valid?
    assert schedule_page.same?(schedule_page_2)

    # execute 4
    schedule_page_2.save!

    # postcondition 4
    assert_equal 1, SchedulePage.all.length

    assert @bucket.object("html/201806/schedule.html").exists?
  end

  test "find" do
    # precondition
    schedule_page_198601 = SchedulePage.download(1986, 1, File.open("test/fixtures/files/schedule.198601.html").read)
    schedule_page_198601.save!

    schedule_page_201806 = SchedulePage.download(2018, 6, File.open("test/fixtures/files/schedule.201806.html").read)
    schedule_page_201806.save!

    schedule_page_201808 = SchedulePage.download(2018, 8, File.open("test/fixtures/files/schedule.201808.html").read)
    schedule_page_201808.save!

    # execute
    schedule_pages = SchedulePage.all

    schedule_page_2 = SchedulePage.find_by_date(2018, 6)

    # postcondition
    assert_equal 3, schedule_pages.length

    assert schedule_page_198601.same?(schedule_pages[0])
    assert schedule_page_201806.same?(schedule_pages[1])
    assert schedule_page_201808.same?(schedule_pages[2])

    assert schedule_page_201806.same?(schedule_page_2)
  end

end
