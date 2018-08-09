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
    # setup
    `rails crawl:download_schedule_pages[2018,6]`

    # execute
    `rails crawl:download_race_list_pages[2018,6]`

    # NOTE: 引数なしで、全期間をダウンロードする
    # `rails crawl:download_race_list_pages`

    # check
    race_list_pages = RaceListPage.find_all

    assert_race_list_201806
  end

  test "download race list page: case 2018-06, and force download" do
    # setup
    setup_race_list_201806

    # execute
    `rails crawl:download_race_list_pages[2018,6,false]`

    # check
    assert_race_list_201806
  end

  test "download race list page: case 2018-06, and missing only" do
    # setup
    setup_race_list_201806

    # execute
    `rails crawl:download_race_list_pages[2018,6,true]`

    # check
    assert_race_list_201806
  end

  def assert_race_list_201806
    race_list_pages = RaceListPage.find_all
    race_list_pages.each { |r| r.download_from_s3! }

    assert_equal 23, race_list_pages.length

    race_list_page = race_list_pages.find { |r| r.race_id == "18050301" }
    assert_equal Time.zone.local(2018, 6, 2), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert_equal 12, race_list_page.result_pages.length
    assert race_list_page.valid?
    assert race_list_page.exists?

    race_list_page = race_list_pages.find { |r| r.race_id == "18090301" }
    assert_equal Time.zone.local(2018, 6, 2), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert_equal 12, race_list_page.result_pages.length
    assert race_list_page.valid?
    assert race_list_page.exists?

    race_list_page = race_list_pages.find { |r| r.race_id == "18050302" }
    assert_equal Time.zone.local(2018, 6, 3), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert_equal 12, race_list_page.result_pages.length
    assert race_list_page.valid?
    assert race_list_page.exists?

    race_list_page = race_list_pages.find { |r| r.race_id == "18090302" }
    assert_equal Time.zone.local(2018, 6, 3), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert_equal 12, race_list_page.result_pages.length
    assert race_list_page.valid?
    assert race_list_page.exists?

    race_list_page = race_list_pages.find { |r| r.race_id == "18050303" }
    assert_equal Time.zone.local(2018, 6, 9), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert_equal 12, race_list_page.result_pages.length
    assert race_list_page.valid?
    assert race_list_page.exists?

    race_list_page = race_list_pages.find { |r| r.race_id == "18090303" }
    assert_equal Time.zone.local(2018, 6, 9), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert_equal 12, race_list_page.result_pages.length
    assert race_list_page.valid?
    assert race_list_page.exists?

    race_list_page = race_list_pages.find { |r| r.race_id == "18050304" }
    assert_equal Time.zone.local(2018, 6, 10), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert_equal 12, race_list_page.result_pages.length
    assert race_list_page.valid?
    assert race_list_page.exists?

    race_list_page = race_list_pages.find { |r| r.race_id == "18090304" }
    assert_equal Time.zone.local(2018, 6, 10), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert_equal 12, race_list_page.result_pages.length
    assert race_list_page.valid?
    assert race_list_page.exists?

    race_list_page = race_list_pages.find { |r| r.race_id == "18020101" }
    assert_equal Time.zone.local(2018, 6, 16), race_list_page.date
    assert_equal "函館", race_list_page.course_name
    assert_equal 12, race_list_page.result_pages.length
    assert race_list_page.valid?
    assert race_list_page.exists?

    race_list_page = race_list_pages.find { |r| r.race_id == "18050305" }
    assert_equal Time.zone.local(2018, 6, 16), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert_equal 12, race_list_page.result_pages.length
    assert race_list_page.valid?
    assert race_list_page.exists?

    race_list_page = race_list_pages.find { |r| r.race_id == "18090305" }
    assert_equal Time.zone.local(2018, 6, 16), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert_equal 12, race_list_page.result_pages.length
    assert race_list_page.valid?
    assert race_list_page.exists?

    race_list_page = race_list_pages.find { |r| r.race_id == "18020102" }
    assert_equal Time.zone.local(2018, 6, 17), race_list_page.date
    assert_equal "函館", race_list_page.course_name
    assert_equal 12, race_list_page.result_pages.length
    assert race_list_page.valid?
    assert race_list_page.exists?

    race_list_page = race_list_pages.find { |r| r.race_id == "18050306" }
    assert_equal Time.zone.local(2018, 6, 17), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert_equal 12, race_list_page.result_pages.length
    assert race_list_page.valid?
    assert race_list_page.exists?

    race_list_page = race_list_pages.find { |r| r.race_id == "18090306" }
    assert_equal Time.zone.local(2018, 6, 17), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert_equal 12, race_list_page.result_pages.length
    assert race_list_page.valid?
    assert race_list_page.exists?

    race_list_page = race_list_pages.find { |r| r.race_id == "18020103" }
    assert_equal Time.zone.local(2018, 6, 23), race_list_page.date
    assert_equal "函館", race_list_page.course_name
    assert_equal 12, race_list_page.result_pages.length
    assert race_list_page.valid?
    assert race_list_page.exists?

    race_list_page = race_list_pages.find { |r| r.race_id == "18050307" }
    assert_equal Time.zone.local(2018, 6, 23), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert_equal 12, race_list_page.result_pages.length
    assert race_list_page.valid?
    assert race_list_page.exists?

    race_list_page = race_list_pages.find { |r| r.race_id == "18090307" }
    assert_equal Time.zone.local(2018, 6, 23), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert_equal 12, race_list_page.result_pages.length
    assert race_list_page.valid?
    assert race_list_page.exists?

    race_list_page = race_list_pages.find { |r| r.race_id == "18020104" }
    assert_equal Time.zone.local(2018, 6, 24), race_list_page.date
    assert_equal "函館", race_list_page.course_name
    assert_equal 12, race_list_page.result_pages.length
    assert race_list_page.valid?
    assert race_list_page.exists?

    race_list_page = race_list_pages.find { |r| r.race_id == "18050308" }
    assert_equal Time.zone.local(2018, 6, 24), race_list_page.date
    assert_equal "東京", race_list_page.course_name
    assert_equal 12, race_list_page.result_pages.length
    assert race_list_page.valid?
    assert race_list_page.exists?

    race_list_page = race_list_pages.find { |r| r.race_id == "18090308" }
    assert_equal Time.zone.local(2018, 6, 24), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert_equal 12, race_list_page.result_pages.length
    assert race_list_page.valid?
    assert race_list_page.exists?

    race_list_page = race_list_pages.find { |r| r.race_id == "18020105" }
    assert_equal Time.zone.local(2018, 6, 30), race_list_page.date
    assert_equal "函館", race_list_page.course_name
    assert_equal 12, race_list_page.result_pages.length
    assert race_list_page.valid?
    assert race_list_page.exists?

    race_list_page = race_list_pages.find { |r| r.race_id == "18030201" }
    assert_equal Time.zone.local(2018, 6, 30), race_list_page.date
    assert_equal "福島", race_list_page.course_name
    assert_equal 12, race_list_page.result_pages.length
    assert race_list_page.valid?
    assert race_list_page.exists?

    race_list_page = race_list_pages.find { |r| r.race_id == "18070301" }
    assert_equal Time.zone.local(2018, 6, 30), race_list_page.date
    assert_equal "中京", race_list_page.course_name
    assert_equal 12, race_list_page.result_pages.length
    assert race_list_page.valid?
    assert race_list_page.exists?
  end

  def setup_race_list_201806
    schedule_page_html = File.open("test/fixtures/files/schedule.201806.html").read
    schedule_page = SchedulePage.new(2018, 6, schedule_page_html)
    schedule_page.save!

    race_list_page_html = File.open("test/fixtures/files/race_list.20180602.tokyo.html").read
    race_list_page = RaceListPage.new("18050301", race_list_page_html)
    race_list_page.save!

    race_list_page_html = File.open("test/fixtures/files/race_list.20180602.hanshin.html").read
    race_list_page = RaceListPage.new("18090301", race_list_page_html)
    race_list_page.save!

    race_list_page_html = File.open("test/fixtures/files/race_list.20180603.tokyo.html").read
    race_list_page = RaceListPage.new("18050302", race_list_page_html)
    race_list_page.save!

    race_list_page_html = File.open("test/fixtures/files/race_list.20180603.hanshin.html").read
    race_list_page = RaceListPage.new("18090302", race_list_page_html)
    race_list_page.save!

    race_list_page_html = File.open("test/fixtures/files/race_list.20180609.tokyo.html").read
    race_list_page = RaceListPage.new("18050303", race_list_page_html)
    race_list_page.save!

    race_list_page_html = File.open("test/fixtures/files/race_list.20180609.hanshin.html").read
    race_list_page = RaceListPage.new("18090303", race_list_page_html)
    race_list_page.save!

    race_list_page_html = File.open("test/fixtures/files/race_list.20180610.tokyo.html").read
    race_list_page = RaceListPage.new("18050304", race_list_page_html)
    race_list_page.save!

    race_list_page_html = File.open("test/fixtures/files/race_list.20180610.hanshin.html").read
    race_list_page = RaceListPage.new("18090304", race_list_page_html)
    race_list_page.save!

    race_list_page_html = File.open("test/fixtures/files/race_list.20180616.hakodate.html").read
    race_list_page = RaceListPage.new("18020101", race_list_page_html)
    race_list_page.save!

    race_list_page_html = File.open("test/fixtures/files/race_list.20180616.tokyo.html").read
    race_list_page = RaceListPage.new("18050305", race_list_page_html)
    race_list_page.save!

    race_list_page_html = File.open("test/fixtures/files/race_list.20180616.hanshin.html").read
    race_list_page = RaceListPage.new("18090305", race_list_page_html)
    race_list_page.save!

    race_list_page_html = File.open("test/fixtures/files/race_list.20180617.hakodate.html").read
    race_list_page = RaceListPage.new("18020102", race_list_page_html)
    race_list_page.save!

    race_list_page_html = File.open("test/fixtures/files/race_list.20180617.tokyo.html").read
    race_list_page = RaceListPage.new("18050306", race_list_page_html)
    race_list_page.save!

    race_list_page_html = File.open("test/fixtures/files/race_list.20180617.hanshin.html").read
    race_list_page = RaceListPage.new("18090306", race_list_page_html)
    race_list_page.save!

    race_list_page_html = File.open("test/fixtures/files/race_list.20180623.hakodate.html").read
    race_list_page = RaceListPage.new("18020103", race_list_page_html)
    race_list_page.save!

    race_list_page_html = File.open("test/fixtures/files/race_list.20180623.tokyo.html").read
    race_list_page = RaceListPage.new("18050307", race_list_page_html)
    race_list_page.save!

    race_list_page_html = File.open("test/fixtures/files/race_list.20180623.hanshin.html").read
    race_list_page = RaceListPage.new("18090307", race_list_page_html)
    race_list_page.save!

    race_list_page_html = File.open("test/fixtures/files/race_list.20180624.hakodate.html").read
    race_list_page = RaceListPage.new("18020104", race_list_page_html)
    race_list_page.save!

    race_list_page_html = File.open("test/fixtures/files/race_list.20180624.tokyo.html").read
    race_list_page = RaceListPage.new("18050308", race_list_page_html)
    race_list_page.save!

    race_list_page_html = File.open("test/fixtures/files/race_list.20180624.hanshin.html").read
    race_list_page = RaceListPage.new("18090308", race_list_page_html)
    race_list_page.save!

    race_list_page_html = File.open("test/fixtures/files/race_list.20180630.hakodate.html").read
    race_list_page = RaceListPage.new("18020105", race_list_page_html)
    race_list_page.save!

    race_list_page_html = File.open("test/fixtures/files/race_list.20180630.fukushima.html").read
    race_list_page = RaceListPage.new("18030201", race_list_page_html)
    race_list_page.save!

    race_list_page_html = File.open("test/fixtures/files/race_list.20180630.chukyo.html").read
    race_list_page = RaceListPage.new("18070301", race_list_page_html)
    race_list_page.save!
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

end
