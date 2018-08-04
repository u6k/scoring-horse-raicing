require 'test_helper'

class SchedulePageTest < ActiveSupport::TestCase

  def setup
    @bucket = NetModule.get_s3_bucket
    @bucket.objects.batch_delete!
  end

  test "download" do
    # execute - 過去月をインスタンス化
    schedule_page = SchedulePage.new(2018, 6)

    # check
    assert 0, SchedulePage.find_all.length

    assert_not schedule_page.exists?
    assert_raises "Content not cached" do
      schedule_page.parse
    end

    # execute - ダウンロード
    schedule_page.download!

    # check
    assert 0, SchedulePage.find_all.length

    assert_not schedule_page.exists?
    assert_not_nil schedule_page.parse

    # execute - 保存
    schedule_page.save!

    # check
    assert 1, SchedulePage.find_all.length

    assert schedule_page.exists?
    assert_not_nil schedule_page.parse

    data1 = schedule_page.parse

    # execute - 再ダウンロードも可能
    schedule_page.download!

    # check
    assert 1, SchedulePage.find_all.length

    assert schedule_page.exists?
    assert_not_nil schedule_page.parse

    assert_equal data1, schedule_page.parse

    # execute - 再保存は上書き
    schedule_page.save!

    # check
    assert 1, SchedulePage.find_all.length

    assert schedule_page.exists?
    assert_not_nil schedule_page.parse
  end

  test "download: 当月の場合" do
    # execute - 当月をインスタンス化
    schedule_page = SchedulePage.new(Time.zone.now.year, Time.zone.now.month)

    # check
    assert 0, SchedulePage.find_all.length

    assert_not schedule_page.exists?
    assert_raises "Content not cached" do
      schedule_page.parse
    end

    # execute - ダウンロード
    schedule_page.download!

    # check
    assert 0, SchedulePage.find_all.length

    assert_not schedule_page.exists?
    assert_not_nil schedule_page.parse

    # execute - 保存
    schedule_page.save!

    # check
    assert 1, SchedulePage.find_all.length

    assert schedule_page.exists?
    assert_not_nil schedule_page.parse

    data1 = schedule_page.parse
  end

  test "download: 来月(リンクが不完全)の場合" do
    # setup
    html = File.open("test/fixtures/files/schedule.201808.html").read

    # execute - 当月をインスタンス化
    schedule_page = SchedulePage.new(2018, 8, html)

    # check
    assert 0, SchedulePage.find_all.length

    assert_not schedule_page.exists?
    assert_not_nil schedule_page.parse

    # execute - 保存
    schedule_page.save!

    # check
    assert 1, SchedulePage.find_all.length

    assert schedule_page.exists?
    assert_not_nil schedule_page.parse
  end

  test "download: ページが存在しない月の場合" do
    # execute - 存在しない月をインスタンス化
    schedule_page = SchedulePage.new(1900, 1)

    # check
    assert 0, SchedulePage.find_all.length

    assert_not schedule_page.exists?
    assert_raises "Content not cached" do
      schedule_page.parse
    end

    # execute - ダウンロード
    assert_raises "Content not found" do
      schedule_page.download!
    end

    # check
    assert 0, SchedulePage.find_all.length

    assert_not schedule_page.exists?
    assert_raises "Content not cached" do
      schedule_page.parse
    end

    # execute - 保存
    assert_raises "Content not downloaded" do
      schedule_page.save!
    end

    # check
    assert 0, SchedulePage.find_all.length

    assert_not schedule_page.exists?
    assert_raises "Content not cached" do
      schedule_page.parse
    end
  end

#  test "parse" do
#    # precondition
#    html = File.open("test/fixtures/files/schedule.201806.html")
#    schedule_page = SchedulePage.download(2018, 6, html)
#
#    # execute
#    page_data = schedule_page.parse
#
#    # postcondition
#    expected_data = [
#      {
#        date: Time.zone.local(2018, 6, 2),
#        url: "https://keiba.yahoo.co.jp/race/list/18050301/",
#        course_name: "東京"
#      },
#      {
#        date: Time.zone.local(2018, 6, 2),
#        url: "https://keiba.yahoo.co.jp/race/list/18090301/",
#        course_name: "阪神"
#      },
#      {
#        date: Time.zone.local(2018, 6, 3),
#        url: "https://keiba.yahoo.co.jp/race/list/18050302/",
#        course_name: "東京"
#      },
#      {
#        date: Time.zone.local(2018, 6, 3),
#        url: "https://keiba.yahoo.co.jp/race/list/18090302/",
#        course_name: "阪神"
#      },
#      {
#        date: Time.zone.local(2018, 6, 9),
#        url: "https://keiba.yahoo.co.jp/race/list/18050303/",
#        course_name: "東京"
#      },
#      {
#        date: Time.zone.local(2018, 6, 9),
#        url: "https://keiba.yahoo.co.jp/race/list/18090303/",
#        course_name: "阪神"
#      },
#      {
#        date: Time.zone.local(2018, 6, 10),
#        url: "https://keiba.yahoo.co.jp/race/list/18050304/",
#        course_name: "東京"
#      },
#      {
#        date: Time.zone.local(2018, 6, 10),
#        url: "https://keiba.yahoo.co.jp/race/list/18090304/",
#        course_name: "阪神"
#      },
#      {
#        date: Time.zone.local(2018, 6, 16),
#        url: "https://keiba.yahoo.co.jp/race/list/18020101/",
#        course_name: "函館"
#      },
#      {
#        date: Time.zone.local(2018, 6, 16),
#        url: "https://keiba.yahoo.co.jp/race/list/18050305/",
#        course_name: "東京"
#      },
#      {
#        date: Time.zone.local(2018, 6, 16),
#        url: "https://keiba.yahoo.co.jp/race/list/18090305/",
#        course_name: "阪神"
#      },
#      {
#        date: Time.zone.local(2018, 6, 17),
#        url: "https://keiba.yahoo.co.jp/race/list/18020102/",
#        course_name: "函館"
#      },
#      {
#        date: Time.zone.local(2018, 6, 17),
#        url: "https://keiba.yahoo.co.jp/race/list/18050306/",
#        course_name: "東京"
#      },
#      {
#        date: Time.zone.local(2018, 6, 17),
#        url: "https://keiba.yahoo.co.jp/race/list/18090306/",
#        course_name: "阪神"
#      },
#      {
#        date: Time.zone.local(2018, 6, 23),
#        url: "https://keiba.yahoo.co.jp/race/list/18020103/",
#        course_name: "函館"
#      },
#      {
#        date: Time.zone.local(2018, 6, 23),
#        url: "https://keiba.yahoo.co.jp/race/list/18050307/",
#        course_name: "東京"
#      },
#      {
#        date: Time.zone.local(2018, 6, 23),
#        url: "https://keiba.yahoo.co.jp/race/list/18090307/",
#        course_name: "阪神"
#      },
#      {
#        date: Time.zone.local(2018, 6, 24),
#        url: "https://keiba.yahoo.co.jp/race/list/18020104/",
#        course_name: "函館"
#      },
#      {
#        date: Time.zone.local(2018, 6, 24),
#        url: "https://keiba.yahoo.co.jp/race/list/18050308/",
#        course_name: "東京"
#      },
#      {
#        date: Time.zone.local(2018, 6, 24),
#        url: "https://keiba.yahoo.co.jp/race/list/18090308/",
#        course_name: "阪神"
#      },
#      {
#        date: Time.zone.local(2018, 6, 30),
#        url: "https://keiba.yahoo.co.jp/race/list/18020105/",
#        course_name: "函館"
#      },
#      {
#        date: Time.zone.local(2018, 6, 30),
#        url: "https://keiba.yahoo.co.jp/race/list/18030201/",
#        course_name: "福島"
#      },
#      {
#        date: Time.zone.local(2018, 6, 30),
#        url: "https://keiba.yahoo.co.jp/race/list/18070301/",
#        course_name: "中京"
#      },
#    ]
#
#    assert_equal page_data, expected_data
#  end

#  test "parse: case line skip" do
#    # precondition
#    html = File.open("test/fixtures/files/schedule.201808.html")
#    schedule_page = SchedulePage.download(2018, 8, html)
#
#    # execute
#    page_data = schedule_page.parse
#
#    # postcondition
#    expected_data = [
#      {
#        date: Time.zone.local(2018, 8, 4),
#        url: "https://keiba.yahoo.co.jp/race/list/18010103/",
#        course_name: "札幌"
#      },
#      {
#        date: Time.zone.local(2018, 8, 4),
#        url: "https://keiba.yahoo.co.jp/race/list/18040203/",
#        course_name: "新潟"
#      },
#      {
#        date: Time.zone.local(2018, 8, 4),
#        url: "https://keiba.yahoo.co.jp/race/list/18100203/",
#        course_name: "小倉"
#      },
#      {
#        date: Time.zone.local(2018, 8, 5),
#        url: "https://keiba.yahoo.co.jp/race/list/18010104/",
#        course_name: "札幌"
#      },
#      {
#        date: Time.zone.local(2018, 8, 5),
#        url: "https://keiba.yahoo.co.jp/race/list/18040204/",
#        course_name: "新潟"
#      },
#      {
#        date: Time.zone.local(2018, 8, 5),
#        url: "https://keiba.yahoo.co.jp/race/list/18100204/",
#        course_name: "小倉"
#      },
#    ]
#
#    assert_equal page_data, expected_data
#  end

#  test "parse: case invalid html" do
#    # precondition
#    schedule_page = SchedulePage.download(1900, 1, "Invalid HTML")
#
#    # execute
#    page_data = schedule_page.parse
#
#    # postcondition
#    assert_nil page_data
#  end

#  test "save, and overwrite" do
#    # execute 1
#    html = File.open("test/fixtures/files/schedule.201806.html").read
#    schedule_page = SchedulePage.download(2018, 6, html)
#
#    # postcondition 1
#    assert_equal 0, SchedulePage.all.length
#
#    assert schedule_page.valid?
#    assert_not @bucket.object("html/201806/schedule.html").exists?
#
#    # execute 2
#    schedule_page.save!
#
#    # postcondition 2
#    assert_equal 1, SchedulePage.all.length
#
#    assert @bucket.object("html/201806/schedule.html").exists?
#
#    # execute 3
#    schedule_page_2 = SchedulePage.download(2018, 6, html)
#
#    # postcondition 3
#    assert_equal 1, SchedulePage.all.length
#
#    assert schedule_page_2.valid?
#    assert schedule_page.same?(schedule_page_2)
#
#    # execute 4
#    schedule_page_2.save!
#
#    # postcondition 4
#    assert_equal 1, SchedulePage.all.length
#
#    assert @bucket.object("html/201806/schedule.html").exists?
#  end

#  test "find" do
#    # precondition
#    schedule_page_198601 = SchedulePage.download(1986, 1, File.open("test/fixtures/files/schedule.198601.html").read)
#    schedule_page_198601.save!
#
#    schedule_page_201806 = SchedulePage.download(2018, 6, File.open("test/fixtures/files/schedule.201806.html").read)
#    schedule_page_201806.save!
#
#    schedule_page_201808 = SchedulePage.download(2018, 8, File.open("test/fixtures/files/schedule.201808.html").read)
#    schedule_page_201808.save!
#
#    # execute
#    schedule_pages = SchedulePage.all
#
#    schedule_page_2 = SchedulePage.find_by_date(2018, 6)
#
#    # postcondition
#    assert_equal 3, schedule_pages.length
#
#    assert schedule_page_198601.same?(schedule_pages[0])
#    assert schedule_page_201806.same?(schedule_pages[1])
#    assert schedule_page_201808.same?(schedule_pages[2])
#
#    assert schedule_page_201806.same?(schedule_page_2)
#  end

end
