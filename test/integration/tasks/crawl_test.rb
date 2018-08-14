require 'test_helper'

class CrawlTest < ActionDispatch::IntegrationTest

  def setup
    @bucket = NetModule.get_s3_bucket
    @bucket.objects.batch_delete!
  end

  test "download schedule page: case 2018-06(default missing only)" do
    # execute
    `rails crawl:download_schedule_pages[2018,6]`

    # NOTE: 引数なしで、全期間をダウンロードする
    # `rails crawl:download_schedule_pages`

    # check
    schedule_pages = SchedulePage.find_all

    assert_equal 1, schedule_pages.length

    schedule_page = schedule_pages[0]
    assert_equal Time.zone.local(2018, 6, 1), schedule_page.date
  end

  test "download schedule page: case 2018-06, and force download" do
    # setup
    schedule_page_html_201806 = File.open("test/fixtures/files/schedule.201806.html").read
    NetModule.put_s3_object(NetModule.get_s3_bucket, "html/schedule/schedule.201806.html", schedule_page_html_201806)

    assert_equal 1, SchedulePage.find_all.length

    # execute
    `rails crawl:download_schedule_pages[2018,6,false]`

    # check
    schedule_pages = SchedulePage.find_all

    assert_equal 1, schedule_pages.length

    schedule_page = schedule_pages[0]
    assert_equal Time.zone.local(2018, 6, 1), schedule_page.date
  end

  test "download schedule page: case 2018-06, and missing only" do
    # setup
    schedule_page_html_201806 = File.open("test/fixtures/files/schedule.201806.html").read
    NetModule.put_s3_object(NetModule.get_s3_bucket, "html/schedule/schedule.201806.html", schedule_page_html_201806)

    assert_equal 1, SchedulePage.find_all.length

    # execute
    `rails crawl:download_schedule_pages[2018,6,true]`

    # check
    schedule_pages = SchedulePage.find_all

    assert_equal 1, schedule_pages.length

    schedule_page = schedule_pages[0]
    assert_equal Time.zone.local(2018, 6, 1), schedule_page.date
  end

  test "download race list page: case 2018-06(default missing only)" do
    # execute
    `rails crawl:download_race_list_pages[,,18090308]`

    # NOTE: 年月指定で、指定年月のレース一覧をダウンロードする
    # `rails crawl:download_race_list_pages[2018,6]`
    # NOTE: 引数なしで、全期間をダウンロードする
    # `rails crawl:download_race_list_pages`

    # check
    assert_race_list_201806
  end

  test "download race list page: case 2018-06, and force download" do
    # setup
    race_list_page_html = File.open("test/fixtures/files/race_list.20180624.hanshin.html").read
    race_list_page = RaceListPage.new("18090308", race_list_page_html)
    race_list_page.save!

    # execute
    `rails crawl:download_race_list_pages[,,18090308,false]`

    # check
    assert_race_list_201806
  end

  test "download race list page: case 2018-06, and missing only" do
    # setup
    race_list_page_html = File.open("test/fixtures/files/race_list.20180624.hanshin.html").read
    race_list_page = RaceListPage.new("18090308", race_list_page_html)
    race_list_page.save!

    # execute
    `rails crawl:download_race_list_pages[,,18090308,true]`

    # check
    assert_race_list_201806
  end

  def assert_race_list_201806
    race_list_pages = RaceListPage.find_all
    race_list_pages.each { |r| r.download_from_s3! }

    assert_equal 1, race_list_pages.length

    race_list_page = race_list_pages[0]
    assert_equal "18090308", race_list_page.race_id
    assert_equal Time.zone.local(2018, 6, 24), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert_equal 12, race_list_page.result_pages.length
    assert race_list_page.valid?
    assert race_list_page.exists?
  end

  test "download race page: case 2018-06-24 阪神(default missing only)" do
    # execute
    `rails crawl:download_race_pages[,,1809030801]`

    # NOTE: 年月指定で、指定年月のレース結果をダウンロードする
    # `rails crawl:download_race_pages[2018,6]`
    # NOTE: 引数なしで、全期間をダウンロードする
    # `rails crawl:download_race_pages`

    # check
    assert_race_page_20180624_hanshin_1r
  end

  test "download race page: case 2018-06-24 阪神, and force download" do
    # setup
    setup_race_page_20180624_hanshin_1r

    # execute
    `rails crawl:download_race_pages[,,1809030801,false]`

    # check
    assert_race_page_20180624_hanshin_1r
  end

  test "download race page: case 2018-06-24 阪神 1R, and missing only" do
    # setup
    setup_race_page_20180624_hanshin_1r

    # execute
    `rails crawl:download_race_pages[,,1809030801,true]`

    # check
    assert_race_page_20180624_hanshin_1r
  end

  def setup_race_page_20180624_hanshin_1r
    result_page_html = File.open("test/fixtures/files/result.20180624.hanshin.1.html").read
    result_page = ResultPage.new("1809030801", result_page_html)
    result_page.save!

    entry_page_html = File.open("test/fixtures/files/entry.20180624.hanshin.1.html").read
    entry_page = EntryPage.new("1809030801", entry_page_html)
    entry_page.save!

    odds_win_page_html = File.open("test/fixtures/files/odds_win.20180624.hanshin.1.html").read
    odds_win_page = OddsWinPage.new("1809030801", odds_win_page_html)
    odds_win_page.save!

    odds_quinella_page_html = File.open("test/fixtures/files/odds_quinella.20180624.hanshin.1.html").read
    odds_quinella_page = OddsQuinellaPage.new("1809030801", odds_quinella_page_html)
    odds_quinella_page.save!

    odds_exacta_page_html = File.open("test/fixtures/files/odds_exacta.20180624.hanshin.1.html").read
    odds_exacta_page = OddsExactaPage.new("1809030801", odds_exacta_page_html)
    odds_exacta_page.save!

    odds_quinella_place_page_html = File.open("test/fixtures/files/odds_quinella_place.20180624.hanshin.1.html").read
    odds_quinella_place_page = OddsQuinellaPlacePage.new("1809030801", odds_quinella_place_page_html)
    odds_quinella_place_page.save!

    odds_trio_page_html = File.open("test/fixtures/files/odds_trio.20180624.hanshin.1.html").read
    odds_trio_page = OddsTrioPage.new("1809030801", odds_trio_page_html)
    odds_trio_page.save!
  end

  def assert_race_page_20180624_hanshin_1r
    result_pages = ResultPage.find_all
    result_pages.each { |r| r.download_from_s3! }

    assert_equal 1, result_pages.length

    result_page = result_pages[0]
    assert_equal "1809030801", result_page.result_id
    assert_equal 1, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 24, 10, 5, 0), result_page.start_datetime
    assert_equal "サラ系3歳未勝利", result_page.race_name
    assert_equal "1809030801", result_page.odds_win_page.odds_id
    assert result_page.valid?
    assert result_page.exists?

    entry_page = result_page.entry_page
    entry_page.download_from_s3!

    assert_equal "1809030801", entry_page.entry_id
    assert_equal 16, entry_page.entries.length
    assert result_page.entry_page.valid?
    assert result_page.entry_page.exists?

    odds_win_page = result_page.odds_win_page
    odds_win_page.download_from_s3!

    assert_equal "1809030801", odds_win_page.odds_id
    assert_not_nil odds_win_page.win_results # FIXME
    assert_not_nil odds_win_page.place_results # FIXME
    assert_not_nil odds_win_page.bracket_quinella_results # FIXME
    assert_equal "1809030801", odds_win_page.odds_quinella_page.odds_id
    assert_equal "1809030801", odds_win_page.odds_quinella_place_page.odds_id
    assert_equal "1809030801", odds_win_page.odds_exacta_page.odds_id
    assert_equal "1809030801", odds_win_page.odds_trio_page.odds_id
    assert_equal "1809030801", odds_win_page.odds_trifecta_page.odds_id
    assert odds_win_page.valid?
    assert odds_win_page.exists?

    odds_quinella_page = odds_win_page.odds_quinella_page
    odds_quinella_page.download_from_s3!

    assert_equal "1809030801", odds_quinella_page.odds_id
    assert_not_nil odds_quinella_page.quinella_results # FIXME
    assert odds_quinella_page.valid?
    assert odds_quinella_page.exists?

    odds_exacta_page = odds_win_page.odds_exacta_page
    odds_exacta_page.download_from_s3!

    assert_equal "1809030801", odds_exacta_page.odds_id
    assert_not_nil odds_exacta_page.exacta_results # FIXME
    assert odds_exacta_page.valid?
    assert odds_exacta_page.exists?

    odds_quinella_place_page = odds_win_page.odds_quinella_place_page
    odds_quinella_place_page.download_from_s3!

    assert_equal "1809030801", odds_quinella_place_page.odds_id
    assert_not_nil odds_quinella_place_page.quinella_place_results # FIXME
    assert odds_quinella_place_page.valid?
    assert odds_quinella_place_page.exists?

    odds_trio_page = odds_win_page.odds_trio_page
    odds_trio_page.download_from_s3!

    assert_equal "1809030801", odds_trio_page.odds_id
    assert_not_nil odds_trio_page.trio_results # FIXME
    assert odds_trio_page.valid?
    assert odds_trio_page.exists?
  end

end
