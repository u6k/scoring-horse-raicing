require 'test_helper'

class RaceListPageTest < ActiveSupport::TestCase

  def setup
    @bucket = NetModule.get_s3_bucket
    @bucket.objects.batch_delete!
  end

  test "download" do
    # precondition
    html = File.open("test/fixtures/files/schedule.201806.html").read
    schedule_page = SchedulePage.download(2018, 6, html)
    schedule_page.save!

    # execute
    race_list_pages = schedule_page.download_race_list_pages

    # postcondition
    assert_equal 0, RaceListPage.all.length

    assert_equal 23, race_list_pages.length

    race_list_page = race_list_pages[0]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18050301/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 2, 0, 0, 0), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180602/race_list_html").exists?

    race_list_page = race_list_pages[1]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18090301/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 2, 0, 0, 0), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180602/race_list.html").exists?

    race_list_page = race_list_pages[2]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18050302/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 3, 0, 0, 0), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180603/race_list.html").exists?

    race_list_page = race_list_pages[3]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18090302/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 3, 0, 0, 0), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180603/race_list.html").exists?

    race_list_page = race_list_pages[4]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18050303/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 9, 0, 0, 0), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180609/race_list.html").exists?

    race_list_page = race_list_pages[5]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18090303/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 9, 0, 0, 0), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180609/race_list.html").exists?

    race_list_page = race_list_pages[6]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18050304/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 10, 0, 0, 0), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180610/race_list.html").exists?

    race_list_page = race_list_pages[7]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18090304/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 10, 0, 0, 0), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180610/race_list.html").exists?

    race_list_page = race_list_pages[8]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18020101/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 16, 0, 0, 0), race_list_page.date
    assert_equal "函館", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180616/race_list.html").exists?

    race_list_page = race_list_pages[9]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18050305/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 16, 0, 0, 0), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180616/race_list.html").exists?

    race_list_page = race_list_pages[10]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18090305/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 16, 0, 0, 0), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180616/race_list.html").exists?

    race_list_page = race_list_pages[11]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18020102/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 17, 0, 0, 0), race_list_page.date
    assert_equal "函館", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180617/race_list.html").exists?

    race_list_page = race_list_pages[12]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18050306/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 17, 0, 0, 0), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180617/race_list.html").exists?

    race_list_page = race_list_pages[13]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18090306/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 17, 0, 0, 0), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180617/race_list.html").exists?

    race_list_page = race_list_pages[14]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18020103/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 23, 0, 0, 0), race_list_page.date
    assert_equal "函館", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180623/race_list.html").exists?

    race_list_page = race_list_pages[15]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18050307/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 23, 0, 0, 0), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180623/race_list.html").exists?

    race_list_page = race_list_pages[16]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18090307/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 23, 0, 0, 0), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180623/race_list.html").exists?

    race_list_page = race_list_pages[17]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18020104/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 24, 0, 0, 0), race_list_page.date
    assert_equal "函館", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180624/race_list.html").exists?

    race_list_page = race_list_pages[18]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18050308/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 24, 0, 0, 0), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180624/race_list.html").exists?

    race_list_page = race_list_pages[19]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18090308/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 24, 0, 0, 0), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180624/race_list.html").exists?

    race_list_page = race_list_pages[20]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18020105/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 30, 0, 0, 0), race_list_page.date
    assert_equal "函館", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180630/race_list.html").exists?

    race_list_page = race_list_pages[21]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18030201/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 30, 0, 0, 0), race_list_page.date
    assert_equal "福島", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180630/race_list.html").exists?

    race_list_page = race_list_pages[22]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18070301/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 30, 0, 0, 0), race_list_page.date
    assert_equal "中京", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180630/race_list.html").exists?
  end

  test "download: case link skip" do
    # precondition
    html = File.open("test/fixtures/files/schedule.201808.html").read
    schedule_page = SchedulePage.download(2018, 8, html)
    schedule_page.save!

    # execute
    race_list_pages = schedule_page.download_race_list_pages

    # postcondition
    assert_equal 0, RaceListPage.all.length

    assert_equal 6, race_list_pages.length

    race_list_page = race_list_pages[0]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18010103/", race_list_page.url
    assert_equal Time.zone.local(2018, 8, 4, 0, 0, 0), race_list_page.date
    assert_equal "札幌", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180804/race_list.html").exists?

    race_list_page = race_list_pages[1]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18040203/", race_list_page.url
    assert_equal Time.zone.local(2018, 8, 4, 0, 0, 0), race_list_page.date
    assert_equal "新潟", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180804/race_list.html").exists?

    race_list_page = race_list_pages[2]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18100203/", race_list_page.url
    assert_equal Time.zone.local(2018, 8, 4, 0, 0, 0), race_list_page.date
    assert_equal "小倉", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180804/race_list.html").exists?

    race_list_page = race_list_pages[3]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18010104/", race_list_page.url
    assert_equal Time.zone.local(2018, 8, 5, 0, 0, 0), race_list_page.date
    assert_equal "札幌", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180805/race_list.html").exists?

    race_list_page = race_list_pages[4]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18040204/", race_list_page.url
    assert_equal Time.zone.local(2018, 8, 5, 0, 0, 0), race_list_page.date
    assert_equal "新潟", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180805/race_list.html").exists?

    race_list_page = race_list_pages[5]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18100204/", race_list_page.url
    assert_equal Time.zone.local(2018, 8, 5, 0, 0, 0), race_list_page.date
    assert_equal "小倉", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180805/race_list.html").exists?
  end

  test "download: case invalid html" do
    # precondition
    schedule_page = SchedulePage.download(1900, 1, "Invalid HTML")

    # execute
    race_list_pages = schedule_page.download_race_list_pages

    # postcondition
    assert_equal 0, RaceListPage.all.length

    assert_nil race_list_pages
  end

end
