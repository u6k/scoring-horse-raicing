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
    assert_not @bucket.object("html/201806/20180602/東京/race_list.html").exists?

    race_list_page = race_list_pages[1]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18090301/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 2, 0, 0, 0), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180602/阪神/race_list.html").exists?

    race_list_page = race_list_pages[2]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18050302/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 3, 0, 0, 0), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180603/東京/race_list.html").exists?

    race_list_page = race_list_pages[3]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18090302/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 3, 0, 0, 0), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180603/阪神/race_list.html").exists?

    race_list_page = race_list_pages[4]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18050303/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 9, 0, 0, 0), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180609/東京/race_list.html").exists?

    race_list_page = race_list_pages[5]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18090303/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 9, 0, 0, 0), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180609/阪神/race_list.html").exists?

    race_list_page = race_list_pages[6]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18050304/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 10, 0, 0, 0), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180610/東京/race_list.html").exists?

    race_list_page = race_list_pages[7]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18090304/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 10, 0, 0, 0), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180610/阪神/race_list.html").exists?

    race_list_page = race_list_pages[8]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18020101/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 16, 0, 0, 0), race_list_page.date
    assert_equal "函館", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180616/函館/race_list.html").exists?

    race_list_page = race_list_pages[9]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18050305/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 16, 0, 0, 0), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180616/東京/race_list.html").exists?

    race_list_page = race_list_pages[10]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18090305/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 16, 0, 0, 0), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180616/阪神/race_list.html").exists?

    race_list_page = race_list_pages[11]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18020102/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 17, 0, 0, 0), race_list_page.date
    assert_equal "函館", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180617/函館/race_list.html").exists?

    race_list_page = race_list_pages[12]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18050306/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 17, 0, 0, 0), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180617/東京/race_list.html").exists?

    race_list_page = race_list_pages[13]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18090306/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 17, 0, 0, 0), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180617/阪神/race_list.html").exists?

    race_list_page = race_list_pages[14]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18020103/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 23, 0, 0, 0), race_list_page.date
    assert_equal "函館", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180623/函館/race_list.html").exists?

    race_list_page = race_list_pages[15]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18050307/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 23, 0, 0, 0), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180623/東京/race_list.html").exists?

    race_list_page = race_list_pages[16]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18090307/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 23, 0, 0, 0), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180623/阪神/race_list.html").exists?

    race_list_page = race_list_pages[17]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18020104/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 24, 0, 0, 0), race_list_page.date
    assert_equal "函館", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180624/函館/race_list.html").exists?

    race_list_page = race_list_pages[18]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18050308/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 24, 0, 0, 0), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180624/東京/race_list.html").exists?

    race_list_page = race_list_pages[19]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18090308/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 24, 0, 0, 0), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180624/阪神/race_list.html").exists?

    race_list_page = race_list_pages[20]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18020105/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 30, 0, 0, 0), race_list_page.date
    assert_equal "函館", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180630/函館/race_list.html").exists?

    race_list_page = race_list_pages[21]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18030201/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 30, 0, 0, 0), race_list_page.date
    assert_equal "福島", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180630/福島/race_list.html").exists?

    race_list_page = race_list_pages[22]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18070301/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 30, 0, 0, 0), race_list_page.date
    assert_equal "中京", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180630/中京/race_list.html").exists?
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
    assert_not @bucket.object("html/201806/20180804/札幌/race_list.html").exists?

    race_list_page = race_list_pages[1]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18040203/", race_list_page.url
    assert_equal Time.zone.local(2018, 8, 4, 0, 0, 0), race_list_page.date
    assert_equal "新潟", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180804/新潟/race_list.html").exists?

    race_list_page = race_list_pages[2]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18100203/", race_list_page.url
    assert_equal Time.zone.local(2018, 8, 4, 0, 0, 0), race_list_page.date
    assert_equal "小倉", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180804/小倉/race_list.html").exists?

    race_list_page = race_list_pages[3]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18010104/", race_list_page.url
    assert_equal Time.zone.local(2018, 8, 5, 0, 0, 0), race_list_page.date
    assert_equal "札幌", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180805/札幌/race_list.html").exists?

    race_list_page = race_list_pages[4]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18040204/", race_list_page.url
    assert_equal Time.zone.local(2018, 8, 5, 0, 0, 0), race_list_page.date
    assert_equal "新潟", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180805/新潟/race_list.html").exists?

    race_list_page = race_list_pages[5]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18100204/", race_list_page.url
    assert_equal Time.zone.local(2018, 8, 5, 0, 0, 0), race_list_page.date
    assert_equal "小倉", race_list_page.course_name
    assert race_list_page.schedule_page.same?(schedule_page)
    assert race_list_page.content.length > 0
    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180805/小倉/race_list.html").exists?
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

  test "parse" do
    # precondition
    schedule_page_html = File.open("test/fixtures/files/schedule.201806.html").read
    schedule_page = SchedulePage.download(2018, 6, schedule_page_html)

    race_list_page_html = File.open("test/fixtures/files/race_list.20180603.tokyo.html").read
    race_list_page = RaceListPage.download(schedule_page, "https://keiba.yahoo.co.jp/race/list/18050301/", Time.zone.local(2018, 6, 3), "東京", race_list_page_html)

    # execute
    page_data = race_list_page.parse

    # postcondition
    expected_data = [
      {
        race_number: 1,
        start_datetime: Time.zone.local(2018, 6, 3, 10, 5, 0),
        race_name: "サラ系3歳未勝利",
        url: "https://keiba.yahoo.co.jp/race/result/1805030201/"
      },
      {
        race_number: 2,
        start_datetime: Time.zone.local(2018, 6, 3, 10, 35, 0),
        race_name: "サラ系3歳未勝利",
        url: "https://keiba.yahoo.co.jp/race/result/1805030202/"
      },
      {
        race_number: 3,
        start_datetime: Time.zone.local(2018, 6, 3, 11, 05, 0),
        race_name: "サラ系3歳未勝利",
        url: "https://keiba.yahoo.co.jp/race/result/1805030203/"
      },
      {
        race_number: 4,
        start_datetime: Time.zone.local(2018, 6, 3, 11, 35, 0),
        race_name: "サラ系3歳未勝利",
        url: "https://keiba.yahoo.co.jp/race/result/1805030204/"
      },
      {
        race_number: 5,
        start_datetime: Time.zone.local(2018, 6, 3, 12, 25, 0),
        race_name: "サラ系2歳新馬",
        url: "https://keiba.yahoo.co.jp/race/result/1805030205/"
      },
      {
        race_number: 6,
        start_datetime: Time.zone.local(2018, 6, 3, 12, 55, 0),
        race_name: "サラ系2歳新馬",
        url: "https://keiba.yahoo.co.jp/race/result/1805030206/"
      },
      {
        race_number: 7,
        start_datetime: Time.zone.local(2018, 6, 3, 13, 25, 0),
        race_name: "サラ系3歳上500万円以下",
        url: "https://keiba.yahoo.co.jp/race/result/1805030207/"
      },
      {
        race_number: 8,
        start_datetime: Time.zone.local(2018, 6, 3, 13, 55, 0),
        race_name: "サラ系3歳上500万円以下",
        url: "https://keiba.yahoo.co.jp/race/result/1805030208/"
      },
      {
        race_number: 9,
        start_datetime: Time.zone.local(2018, 6, 3, 14, 25, 0),
        race_name: "ホンコンジョッキークラブトロフィー",
        url: "https://keiba.yahoo.co.jp/race/result/1805030209/"
      },
      {
        race_number: 10,
        start_datetime: Time.zone.local(2018, 6, 3, 15, 01, 0),
        race_name: "由比ヶ浜特別",
        url: "https://keiba.yahoo.co.jp/race/result/1805030210/"
      },
      {
        race_number: 11,
        start_datetime: Time.zone.local(2018, 6, 3, 15, 40, 0),
        race_name: "安田記念（GI）",
        url: "https://keiba.yahoo.co.jp/race/result/1805030211/"
      },
      {
        race_number: 12,
        start_datetime: Time.zone.local(2018, 6, 3, 16, 25, 0),
        race_name: "三浦特別",
        url: "https://keiba.yahoo.co.jp/race/result/1805030212/"
      },
    ]

    assert_equal page_data, expected_data
  end

  test "parse: case invalid html" do
    # precondition
    html = File.open("test/fixtures/files/schedule.201808.html").read
    schedule_page = SchedulePage.download(2018, 8, html)

    race_list_page = RaceListPage.download(schedule_page, "https://keiba.yahoo.co.jp/race/list/00000000/", Time.zone.local(1900, 1, 1), "東京", "Invalid html")

    # execute
    page_data = race_list_page.parse

    # postcondition
    assert_nil page_data
  end

  test "save, and overwrite" do
    # precondition
    schedule_page_html = File.open("test/fixtures/files/schedule.201806.html").read
    schedule_page = SchedulePage.download(2018, 6, schedule_page_html)
    schedule_page.save!

    race_list_page_html = File.open("test/fixtures/files/race_list.20180603.tokyo.html").read

    # execute 1
    race_list_page = RaceListPage.download(schedule_page, "https://keiba.yahoo.co.jp/race/list/18050301/", Time.zone.local(2018, 6, 3), "東京", race_list_page_html)

    # postcondition 1
    assert_equal 0, RaceListPage.all.length

    assert race_list_page.valid?
    assert_not @bucket.object("html/201806/20180603/東京/race_list.html").exists?

    # execute 2
    race_list_page.save!

    # postcondition 2
    assert_equal 1, RaceListPage.all.length

    assert @bucket.object("html/201806/20180603/東京/race_list.html").exists?

    # execute 3
    race_list_page_2 = RaceListPage.download(schedule_page, "https://keiba.yahoo.co.jp/race/list/18050301/", Time.zone.local(2018, 6, 3), "東京", race_list_page_html)

    # postcondition 3
    assert_equal 1, RaceListPage.all.length

    assert race_list_page_2.valid?
    assert race_list_page.same?(race_list_page_2)

    # execute 4
    race_list_page_2.save!

    # postcondition 4
    assert_equal 1, RaceListPage.all.length

    assert @bucket.object("html/201806/20180603/東京/race_list.html").exists?
  end

  test "find" do
    # precondition
    schedule_page_html = File.open("test/fixtures/files/schedule.201806.html").read
    schedule_page = SchedulePage.download(2018, 6, schedule_page_html)
    schedule_page.save!

    race_list_page_html = File.open("test/fixtures/files/race_list.20180603.tokyo.html").read
    race_list_page = RaceListPage.download(schedule_page, "https://keiba.yahoo.co.jp/race/list/18050301/", Time.zone.local(2018, 6, 3), "東京", race_list_page_html)
    race_list_page.save!

    # execute
    race_list_pages = schedule_page.race_list_pages

    # postcondition
    assert_equal 1, race_list_pages.length

    assert race_list_page.same?(race_list_pages[0])
  end

end
