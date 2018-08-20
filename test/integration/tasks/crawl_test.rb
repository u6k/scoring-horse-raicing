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

    (1..16).each do |horse_number|
      odds_trifecta_page_html = File.open("test/fixtures/files/odds_trifecta.20180624.hanshin.1.#{horse_number}.html").read
      odds_trifecta_page = OddsTrifectaPage.new("1809030801", horse_number, odds_trifecta_page_html)
      odds_trifecta_page.save!
    end

    ["2015104308", "2015104964", "2015100632", "2015100586", "2015103335", "2015104928", "2015106259", "2015102694", "2015102837", "2015105363", "2015101618", "2015102853", "2015103462", "2015103590", "2015104979", "2015103557"].each do |horse_id|
      horse_page_html = File.open("test/fixtures/files/horse.#{horse_id}.html").read
      horse_page = HorsePage.new(horse_id, horse_page_html)
      horse_page.save!
    end
  end

  def assert_race_page_20180624_hanshin_1r
    # result page
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

    # entry page
    entry_page = result_page.entry_page
    entry_page.download_from_s3!

    assert_equal "1809030801", entry_page.entry_id
    assert_equal 16, entry_page.entries.length
    assert result_page.entry_page.valid?
    assert result_page.entry_page.exists?

    # odds page
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

    odds_trifecta_page = odds_win_page.odds_trifecta_page
    odds_trifecta_page.download_from_s3!

    assert_equal "1809030801", odds_trifecta_page.odds_id
    assert_equal 1, odds_trifecta_page.horse_number
    assert_not_nil odds_trifecta_page.trifecta_results # FIXME
    assert_equal 16, odds_trifecta_page.odds_trifecta_pages.length
    assert odds_trifecta_page.valid?
    assert odds_trifecta_page.exists?

    (1..16).each do |horse_number|
      odds_trifecta_sub_page = odds_trifecta_page.odds_trifecta_pages[horse_number]
      odds_trifecta_sub_page.download_from_s3!

      assert_equal "1809030801", odds_trifecta_sub_page.odds_id
      assert_equal horse_number, odds_trifecta_sub_page.horse_number
      assert_not_nil odds_trifecta_sub_page.trifecta_results
      assert odds_trifecta_sub_page.odds_trifecta_pages.length > 0
      assert odds_trifecta_sub_page.valid?
      assert odds_trifecta_sub_page.exists?
    end

    # horse page
    entries = entry_page.entries
    entries.each { |e| e[:horse].download_from_s3! }

    assert_equal 16, entries.length

    horse_page = entries[0][:horse]
    assert_equal "2015104308", horse_page.horse_id
    assert_equal "プロネルクール", horse_page.horse_name
    assert horse_page.valid?
    assert horse_page.exists?

    horse_page = entries[1][:horse]
    assert_equal "2015104964", horse_page.horse_id
    assert_equal "スーブレット", horse_page.horse_name
    assert horse_page.valid?
    assert horse_page.exists?

    horse_page = entries[2][:horse]
    assert_equal "2015100632", horse_page.horse_id
    assert_equal "アデル", horse_page.horse_name
    assert horse_page.valid?
    assert horse_page.exists?

    horse_page = entries[3][:horse]
    assert_equal "2015100586", horse_page.horse_id
    assert_equal "ヤマニンフィオッコ", horse_page.horse_name
    assert horse_page.valid?
    assert horse_page.exists?

    horse_page = entries[4][:horse]
    assert_equal "2015103335", horse_page.horse_id
    assert_equal "メイショウハニー", horse_page.horse_name
    assert horse_page.valid?
    assert horse_page.exists?

    horse_page = entries[5][:horse]
    assert_equal "2015104928", horse_page.horse_id
    assert_equal "レンブランサ", horse_page.horse_name
    assert horse_page.valid?
    assert horse_page.exists?

    horse_page = entries[6][:horse]
    assert_equal "2015106259", horse_page.horse_id
    assert_equal "アンジェレッタ", horse_page.horse_name
    assert horse_page.valid?
    assert horse_page.exists?

    horse_page = entries[7][:horse]
    assert_equal "2015102694", horse_page.horse_id
    assert_equal "テーオーパートナー", horse_page.horse_name
    assert horse_page.valid?
    assert horse_page.exists?

    horse_page = entries[8][:horse]
    assert_equal "2015102837", horse_page.horse_id
    assert_equal "ウインタイムリープ", horse_page.horse_name
    assert horse_page.valid?
    assert horse_page.exists?

    horse_page = entries[9][:horse]
    assert_equal "2015105363", horse_page.horse_id
    assert_equal "モリノマリン", horse_page.horse_name
    assert horse_page.valid?
    assert horse_page.exists?

    horse_page = entries[10][:horse]
    assert_equal "2015101618", horse_page.horse_id
    assert_equal "プロムクイーン", horse_page.horse_name
    assert horse_page.valid?
    assert horse_page.exists?

    horse_page = entries[11][:horse]
    assert_equal "2015102853", horse_page.horse_id
    assert_equal "ナイスドゥ", horse_page.horse_name
    assert horse_page.valid?
    assert horse_page.exists?

    horse_page = entries[12][:horse]
    assert_equal "2015103462", horse_page.horse_id
    assert_equal "アクアレーヌ", horse_page.horse_name
    assert horse_page.valid?
    assert horse_page.exists?

    horse_page = entries[13][:horse]
    assert_equal "2015103590", horse_page.horse_id
    assert_equal "モンテルース", horse_page.horse_name
    assert horse_page.valid?
    assert horse_page.exists?

    horse_page = entries[14][:horse]
    assert_equal "2015104979", horse_page.horse_id
    assert_equal "リーズン", horse_page.horse_name
    assert horse_page.valid?
    assert horse_page.exists?

    horse_page = entries[15][:horse]
    assert_equal "2015103557", horse_page.horse_id
    assert_equal "スマートスピカ", horse_page.horse_name
    assert horse_page.valid?
    assert horse_page.exists?
  end

end
