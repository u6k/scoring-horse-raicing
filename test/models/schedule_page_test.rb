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

  test "download current month" do
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

  test "parse" do
    # precondition
    html = File.open("test/fixtures/files/schedule.201806.html")
    schedule_page = SchedulePage.download(2018, 6, html)

    # execute
    page_data = schedule_page.parse

    # posrcondition
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

end
