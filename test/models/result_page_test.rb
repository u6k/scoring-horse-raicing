require 'test_helper'

class ResultPageTest < ActiveSupport::TestCase

  def setup
    @bucket = NetModule.get_s3_bucket
    @bucket.objects.batch_delete!
  end

  test "download" do
    # precondition
    schedule_page_html = File.open("test/fixtures/files/schedule.201806.html").read
    schedule_page = SchedulePage.download(2018, 6, schedule_page_html)

    race_list_page_html = File.open("test/fixtures/files/race_list.20180603.tokyo.html").read
    race_list_page = RaceListPage.download(schedule_page, "https://keiba.yahoo.co.jp/race/list/18050301/", Time.zone.local(2018, 6, 3), "東京", race_list_page_html)

    # execute
    result_pages = race_list_page.download_result_pages

    # postcondition
    assert_equal 0, ResultPage.all.length

    assert_equal 12, result_pages.length

    result_page = result_pages[0]
    assert_equal "https://keiba.yahoo.co.jp/race/result/1805030201/", result_page.url
    assert_equal 1, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 3, 10, 5, 0), result_page.start_datetime
    assert_equal "サラ系3歳未勝利", result_page.race_name
    assert result_page.race_list_page.same?(race_list_page)
    assert result_page.content.length > 0
    assert result_page.valid?
    assert_not @bucket.object("html/201806/20180602/東京/1/result.html").exists?

    result_page = result_pages[1]
    assert_equal "https://keiba.yahoo.co.jp/race/result/1805030202/", result_page.url
    assert_equal 2, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 3, 10, 35, 0), result_page.start_datetime
    assert_equal "サラ系3歳未勝利", result_page.race_name
    assert result_page.race_list_page.same?(race_list_page)
    assert result_page.content.length > 0
    assert result_page.valid?
    assert_not @bucket.object("html/201806/20180602/東京/2/result.html").exists?

    result_page = result_pages[2]
    assert_equal "https://keiba.yahoo.co.jp/race/result/1805030203/", result_page.url
    assert_equal 3, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 3, 11, 05, 0), result_page.start_datetime
    assert_equal "サラ系3歳未勝利", result_page.race_name
    assert result_page.race_list_page.same?(race_list_page)
    assert result_page.content.length > 0
    assert result_page.valid?
    assert_not @bucket.object("html/201806/20180602/東京/3/result.html").exists?

    result_page = result_pages[3]
    assert_equal "https://keiba.yahoo.co.jp/race/result/1805030204/", result_page.url
    assert_equal 4, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 3, 11, 35, 0), result_page.start_datetime
    assert_equal "サラ系3歳未勝利", result_page.race_name
    assert result_page.race_list_page.same?(race_list_page)
    assert result_page.content.length > 0
    assert result_page.valid?
    assert_not @bucket.object("html/201806/20180602/東京/4/result.html").exists?

    result_page = result_pages[4]
    assert_equal "https://keiba.yahoo.co.jp/race/result/1805030205/", result_page.url
    assert_equal 5, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 3, 12, 25, 0), result_page.start_datetime
    assert_equal "サラ系2歳新馬", result_page.race_name
    assert result_page.race_list_page.same?(race_list_page)
    assert result_page.content.length > 0
    assert result_page.valid?
    assert_not @bucket.object("html/201806/20180602/東京/5/result.html").exists?

    result_page = result_pages[5]
    assert_equal "https://keiba.yahoo.co.jp/race/result/1805030206/", result_page.url
    assert_equal 6, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 3, 12, 55, 0), result_page.start_datetime
    assert_equal "サラ系2歳新馬", result_page.race_name
    assert result_page.race_list_page.same?(race_list_page)
    assert result_page.content.length > 0
    assert result_page.valid?
    assert_not @bucket.object("html/201806/20180602/東京/6/result.html").exists?

    result_page = result_pages[6]
    assert_equal "https://keiba.yahoo.co.jp/race/result/1805030207/", result_page.url
    assert_equal 7, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 3, 13, 25, 0), result_page.start_datetime
    assert_equal "サラ系3歳上500万円以下", result_page.race_name
    assert result_page.race_list_page.same?(race_list_page)
    assert result_page.content.length > 0
    assert result_page.valid?
    assert_not @bucket.object("html/201806/20180602/東京/7/result.html").exists?

    result_page = result_pages[7]
    assert_equal "https://keiba.yahoo.co.jp/race/result/1805030208/", result_page.url
    assert_equal 8, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 3, 13, 55, 0), result_page.start_datetime
    assert_equal "サラ系3歳上500万円以下", result_page.race_name
    assert result_page.race_list_page.same?(race_list_page)
    assert result_page.content.length > 0
    assert result_page.valid?
    assert_not @bucket.object("html/201806/20180602/東京/8/result.html").exists?

    result_page = result_pages[8]
    assert_equal "https://keiba.yahoo.co.jp/race/result/1805030209/", result_page.url
    assert_equal 9, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 3, 14, 25, 0), result_page.start_datetime
    assert_equal "ホンコンジョッキークラブトロフィー", result_page.race_name
    assert result_page.race_list_page.same?(race_list_page)
    assert result_page.content.length > 0
    assert result_page.valid?
    assert_not @bucket.object("html/201806/20180602/東京/9/result.html").exists?

    result_page = result_pages[9]
    assert_equal "https://keiba.yahoo.co.jp/race/result/1805030210/", result_page.url
    assert_equal 10, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 3, 15, 01, 0), result_page.start_datetime
    assert_equal "由比ヶ浜特別", result_page.race_name
    assert result_page.race_list_page.same?(race_list_page)
    assert result_page.content.length > 0
    assert result_page.valid?
    assert_not @bucket.object("html/201806/20180602/東京/10/result.html").exists?

    result_page = result_pages[10]
    assert_equal "https://keiba.yahoo.co.jp/race/result/1805030211/", result_page.url
    assert_equal 11, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 3, 15, 40, 0), result_page.start_datetime
    assert_equal "安田記念（GI）", result_page.race_name
    assert result_page.race_list_page.same?(race_list_page)
    assert result_page.content.length > 0
    assert result_page.valid?
    assert_not @bucket.object("html/201806/20180602/東京/11/result.html").exists?

    result_page = result_pages[11]
    assert_equal "https://keiba.yahoo.co.jp/race/result/1805030212/", result_page.url
    assert_equal 12, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 3, 16, 25, 0), result_page.start_datetime
    assert_equal "三浦特別", result_page.race_name
    assert result_page.race_list_page.same?(race_list_page)
    assert result_page.content.length > 0
    assert result_page.valid?
    assert_not @bucket.object("html/201806/20180602/東京/12/result.html").exists?
  end

  test "download: case invalid html" do
    # precondition
    schedule_page_html = File.open("test/fixtures/files/schedule.201806.html").read
    schedule_page = SchedulePage.download(2018, 6, schedule_page_html)

    race_list_page = RaceListPage.download(schedule_page, "https://keiba.yahoo.co.jp/race/list/18050301/", Time.zone.local(2018, 6, 3), "東京", "Invalid html")

    # execute
    result_pages = race_list_page.download_result_pages

    # postcondition
    assert_equal 0, ResultPage.all.length

    assert_nil result_pages
  end

end
