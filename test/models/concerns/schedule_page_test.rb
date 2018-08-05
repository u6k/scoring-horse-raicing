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
    assert_not schedule_page.valid?

    # execute - ダウンロード
    schedule_page.download!

    # check
    assert 0, SchedulePage.find_all.length

    assert_not schedule_page.exists?
    assert schedule_page.valid?

    # execute - 保存
    schedule_page.save!

    # check
    assert 1, SchedulePage.find_all.length

    assert schedule_page.exists?
    assert schedule_page.valid?

    # execute - 再インスタンス化
    schedule_page_2 = SchedulePage.new(2018, 6)

    # check
    assert 1, SchedulePage.find_all.length

    assert schedule_page_2.exists?
    assert schedule_page_2.valid?

    # execute - 再ダウンロードも可能
    schedule_page_2.download!

    # check
    assert 1, SchedulePage.find_all.length

    assert schedule_page_2.exists?
    assert schedule_page_2.valid?

    # execute - 再保存は上書き
    schedule_page_2.save!

    # check
    assert 1, SchedulePage.find_all.length

    assert schedule_page_2.exists?
    assert schedule_page_2.valid?
  end

  test "download: 当月の場合" do
    # execute - 当月をインスタンス化
    schedule_page = SchedulePage.new(Time.zone.now.year, Time.zone.now.month)

    # check
    assert 0, SchedulePage.find_all.length

    assert_not schedule_page.exists?
    assert_not schedule_page.valid?

    # execute - ダウンロード
    schedule_page.download!

    # check
    assert 0, SchedulePage.find_all.length

    assert_not schedule_page.exists?
    assert schedule_page.valid?

    # execute - 保存
    schedule_page.save!

    # check
    assert 1, SchedulePage.find_all.length

    assert schedule_page.exists?
    assert schedule_page.valid?
  end

  test "download: 来月(リンクが不完全)の場合" do
    # setup
    html = File.open("test/fixtures/files/schedule.201808.html").read

    # execute - 当月をインスタンス化
    schedule_page = SchedulePage.new(2018, 8, html)

    # check
    assert 0, SchedulePage.find_all.length

    assert_not schedule_page.exists?
    assert schedule_page.valid?

    # execute - 保存
    schedule_page.save!

    # check
    assert 1, SchedulePage.find_all.length

    assert schedule_page.exists?
    assert schedule_page.valid?
  end

  test "download: ページが存在しない月の場合" do
    # execute - 存在しない月をインスタンス化
    schedule_page = SchedulePage.new(1900, 1)

    # check
    assert 0, SchedulePage.find_all.length

    assert_not schedule_page.exists?
    assert_not schedule_page.valid?

    # execute - ダウンロード
    schedule_page.download!

    # check
    assert 0, SchedulePage.find_all.length

    assert_not schedule_page.exists?
    assert_not schedule_page.valid?

    # execute - 保存
    assert_raises "Invalid" do
      schedule_page.save!
    end

    # check
    assert 0, SchedulePage.find_all.length

    assert_not schedule_page.exists?
    assert_not schedule_page.valid?
  end

  test "parse" do
    # precondition
    html = File.open("test/fixtures/files/schedule.201806.html").read
    schedule_page = SchedulePage.new(2018, 6, html)

    # execute
    race_list_pages = schedule_page.race_list_pages

    # postcondition
    assert schedule_page.valid?

    assert_equal 23, race_list_pages.length

    race_list_page = race_list_pages[0]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18050301/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 2), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[1]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18090301/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 2), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[2]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18050302/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 3), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[3]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18090302/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 3), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[4]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18050303/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 9), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[5]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18090303/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 9), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[6]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18050304/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 10), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[7]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18090304/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 10), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[8]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18020101/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 16), race_list_page.date
    assert_equal "函館", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[9]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18050305/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 16), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[10]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18090305/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 16), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[11]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18020102/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 17), race_list_page.date
    assert_equal "函館", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[12]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18050306/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 17), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[13]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18090306/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 17), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[14]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18020103/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 23), race_list_page.date
    assert_equal "函館", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[15]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18050307/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 23), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[16]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18090307/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 23), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[17]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18020104/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 24), race_list_page.date
    assert_equal "函館", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[18]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18050308/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 24), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[19]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18090308/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 24), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[20]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18020105/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 30), race_list_page.date
    assert_equal "函館", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[21]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18030201/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 30), race_list_page.date
    assert_equal "福島", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[22]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18070301/", race_list_page.url
    assert_equal Time.zone.local(2018, 6, 30), race_list_page.date
    assert_equal "中京", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?
  end

  test "parse: case line skip" do
    # precondition
    html = File.open("test/fixtures/files/schedule.201808.html").read
    schedule_page = SchedulePage.new(2018, 8, html)

    # execute
    race_list_pages = schedule_page.race_list_pages

    # postcondition
    assert schedule_page.valid?

    assert_equal 6, race_list_pages.length
 
    race_list_page = race_list_pages[0]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18010103/", race_list_page.url
    assert_equal Time.zone.local(2018, 8, 4), race_list_page.date
    assert_equal "札幌", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[1]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18040203/", race_list_page.url
    assert_equal Time.zone.local(2018, 8, 4), race_list_page.date
    assert_equal "新潟", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[2]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18100203/", race_list_page.url
    assert_equal Time.zone.local(2018, 8, 4), race_list_page.date
    assert_equal "小倉", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[3]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18010104/", race_list_page.url
    assert_equal Time.zone.local(2018, 8, 5), race_list_page.date
    assert_equal "札幌", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[4]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18040204/", race_list_page.url
    assert_equal Time.zone.local(2018, 8, 5), race_list_page.date
    assert_equal "新潟", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[5]
    assert_equal "https://keiba.yahoo.co.jp/race/list/18100204/", race_list_page.url
    assert_equal Time.zone.local(2018, 8, 5), race_list_page.date
    assert_equal "小倉", race_list_page.course_name
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?
  end

  test "parse: case invalid html" do
    # precondition
    schedule_page = SchedulePage.new(1900, 1, "Invalid HTML")

    # execute
    race_list_pages = schedule_page.race_list_pages

    # postcondition
    assert_not schedule_page.valid?

    assert_nil race_list_pages
  end

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
