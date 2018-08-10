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

  test "download result page: case 2018-06-24 阪神(default missing only)" do
    # execute
    `rails crawl:download_result_pages[,,1809030801]`

    # NOTE: 年月指定で、指定年月のレース結果をダウンロードする
    # `rails crawl:download_result_pages[2018,6]`
    # NOTE: 引数なしで、全期間をダウンロードする
    # `rails crawl:download_result_pages`

    # check
    assert_result_page_20180624_hanshin
  end

  test "download result page: case 2018-06-24 阪神, and force download" do
    # setup
    result_page_html = File.open("test/fixtures/files/result.20180624.hanshin.1.html")
    result_page = ResultPage.new("1809030801", result_page_html)
    result_page.save!

    # execute
    `rails crawl:download_result_pages[,,1809030801,false]`

    # check
    assert_result_page_20180624_hanshin
  end

  test "download result page: case 2018-06-24 阪神, and missing only" do
    # setup
    result_page_html = File.open("test/fixtures/files/result.20180624.hanshin.1.html")
    result_page = ResultPage.new("1809030801", result_page_html)
    result_page.save!

    # execute
    `rails crawl:download_result_pages[,,1809030801,true]`

    # check
    assert_result_page_20180624_hanshin
  end

  def assert_result_page_20180624_hanshin
    result_pages = ResultPage.find_all
    result_pages.each { |r| r.download_from_s3! }

    assert_equal 1, result_pages.length

    result_page = result_pages[0]
    assert_equal "1809030801", result_page.result_id
    assert_equal 1, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 24, 10, 5, 0), result_page.start_datetime
    assert_equal "サラ系3歳未勝利", result_page.race_name
    assert_equal "1809030801", result_page.entry_page.entry_id
    assert_equal "1809030801", result_page.odds_win_page.odds_win_id
    assert result_page.valid?
    assert result_page.exists?
  end

  test "download entry page: case 2018-06-24 阪神(default missing only)" do
    # execute
    `rails crawl:download_entry_pages[,,1809030801]`

    # NOTE: 年月指定で、指定年月のレース結果をダウンロードする
    # `rails crawl:download_entry_pages[2018,6]`
    # NOTE: 引数なしで、全期間をダウンロードする
    # `rails crawl:download_entry_pages`

    # check
    assert_entry_page_20180624_hanshin
  end

  test "download entry page: case 2018-06-24 阪神, and force download" do
    # setup
    entry_page_html = File.open("test/fixtures/files/entry.20180624.hanshin.1.html")
    entry_page = ResultPage.new("1809030801", entry_page_html)
    entry_page.save!

    # execute
    `rails crawl:download_entry_pages[,,1809030801,false]`

    # check
    assert_entry_page_20180624_hanshin
  end

  test "download entry page: case 2018-06-24 阪神, and missing only" do
    # setup
    entry_page_html = File.open("test/fixtures/files/entry.20180624.hanshin.1.html")
    entry_page = ResultPage.new("1809030801", entry_page_html)
    entry_page.save!

    # execute
    `rails crawl:download_entry_pages[,,1809030801,true]`

    # check
    assert_entry_page_20180624_hanshin
  end

  def assert_result_page_20180624_hanshin
    entry_pages = EntryPage.find_all
    entry_pages.each { |e| e.download_from_s3! }

    assert_equal 1, entry_pages.length

    entry_page = entry_pages[0]
    assert_equal "1809030801", entry_page.entry_id
    assert_equal 16, entry_page.entries.length
    assert entry_page.valid?
    assert entry_page.exists?

    entry = entry_page.entries[0]
    assert_equal 1, entry[:bracket_number]
    assert_equal 1, entry[:horse_number]
    assert_equal "2015104308", entry[:horse].horse_id
    assert_equal "01120", entry[:trainer].trainer_id
    assert_equal "05339", entry[:jockey].jockey_id

    entry = entry_page.entries[1]
    assert_equal 1, entry[:bracket_number]
    assert_equal 2, entry[:horse_number]
    assert_equal "2015104964", entry[:horse].horse_id
    assert_equal "01022", entry[:trainer].trainer_id
    assert_equal "01014", entry[:jockey].jockey_id

    entry = entry_page.entries[2]
    assert_equal 2, entry[:bracket_number]
    assert_equal 3, entry[:horse_number]
    assert_equal "2015100632", entry[:horse].horse_id
    assert_equal "01046", entry[:trainer].trainer_id
    assert_equal "01088", entry[:jockey].jockey_id

    entry = entry_page.entries[3]
    assert_equal 2, entry[:bracket_number]
    assert_equal 4, entry[:horse_number]
    assert_equal "2015100586", entry[:horse].horse_id
    assert_equal "01140", entry[:trainer].trainer_id
    assert_equal "01114", entry[:jockey].jockey_id

    entry = entry_page.entries[4]
    assert_equal 3, entry[:bracket_number]
    assert_equal 5, entry[:horse_number]
    assert_equal "2015103335", entry[:horse].horse_id
    assert_equal "01041", entry[:trainer].trainer_id
    assert_equal "01165", entry[:jockey].jockey_id

    entry = entry_page.entries[5]
    assert_equal 3, entry[:bracket_number]
    assert_equal 6, entry[:horse_number]
    assert_equal "2015104928", entry[:horse].horse_id
    assert_equal "01073", entry[:trainer].trainer_id
    assert_equal "00894", entry[:jockey].jockey_id

    entry = entry_page.entries[6]
    assert_equal 4, entry[:bracket_number]
    assert_equal 7, entry[:horse_number]
    assert_equal "2015106259", entry[:horse].horse_id
    assert_equal "01078", entry[:trainer].trainer_id
    assert_equal "01034", entry[:jockey].jockey_id

    entry = entry_page.entries[7]
    assert_equal 4, entry[:bracket_number]
    assert_equal 8, entry[:horse_number]
    assert_equal "2015102694", entry[:horse].horse_id
    assert_equal "01104", entry[:trainer].trainer_id
    assert_equal "05203", entry[:jockey].jockey_id

    entry = entry_page.entries[8]
    assert_equal 5, entry[:bracket_number]
    assert_equal 9, entry[:horse_number]
    assert_equal "2015102837", entry[:horse].horse_id
    assert_equal "01050", entry[:trainer].trainer_id
    assert_equal "01126", entry[:jockey].jockey_id

    entry = entry_page.entries[9]
    assert_equal 5, entry[:bracket_number]
    assert_equal 10, entry[:horse_number]
    assert_equal "2015105363", entry[:horse].horse_id
    assert_equal "01138", entry[:trainer].trainer_id
    assert_equal "01019", entry[:jockey].jockey_id

    entry = entry_page.entries[10]
    assert_equal 6, entry[:bracket_number]
    assert_equal 11, entry[:horse_number]
    assert_equal "2015101618", entry[:horse].horse_id
    assert_equal "01066", entry[:trainer].trainer_id
    assert_equal "01166", entry[:jockey].jockey_id

    entry = entry_page.entries[11]
    assert_equal 6, entry[:bracket_number]
    assert_equal 12, entry[:horse_number]
    assert_equal "2015102853", entry[:horse].horse_id
    assert_equal "01111", entry[:trainer].trainer_id
    assert_equal "01018", entry[:jockey].jockey_id

    entry = entry_page.entries[12]
    assert_equal 7, entry[:bracket_number]
    assert_equal 13, entry[:horse_number]
    assert_equal "2015103462", entry[:horse].horse_id
    assert_equal "00356", entry[:trainer].trainer_id
    assert_equal "01130", entry[:jockey].jockey_id

    entry = entry_page.entries[13]
    assert_equal 7, entry[:bracket_number]
    assert_equal 14, entry[:horse_number]
    assert_equal "2015103590", entry[:horse].horse_id
    assert_equal "01157", entry[:trainer].trainer_id
    assert_equal "05386", entry[:jockey].jockey_id

    entry = entry_page.entries[14]
    assert_equal 8, entry[:bracket_number]
    assert_equal 15, entry[:horse_number]
    assert_equal "2015104979", entry[:horse].horse_id
    assert_equal "00438", entry[:trainer].trainer_id
    assert_equal "01116", entry[:jockey].jockey_id

    entry = entry_page.entries[15]
    assert_equal 8, entry[:bracket_number]
    assert_equal 16, entry[:horse_number]
    assert_equal "2015103557", entry[:horse].horse_id
    assert_equal "01022", entry[:trainer].trainer_id
    assert_equal "01154", entry[:jockey].jockey_id
  end

end
