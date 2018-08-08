require 'test_helper'

class RaceListPageTest < ActiveSupport::TestCase

  def setup
    @bucket = NetModule.get_s3_bucket
    @bucket.objects.batch_delete!
  end

  test "download" do
    # setup
    schedule_page_html = File.open("test/fixtures/files/schedule.201806.html").read
    schedule_page = SchedulePage.new(2018, 6, schedule_page_html)

    # execute
    race_list_pages = schedule_page.race_list_pages

    # check
    assert_equal 0, RaceListPage.find_all.length

    assert_equal 23, race_list_pages.length

    race_list_page = race_list_pages[0]
    assert_equal "18050301", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[1]
    assert_equal "18090301", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[2]
    assert_equal "18050302", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[3]
    assert_equal "18090302", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[4]
    assert_equal "18050303", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[5]
    assert_equal "18090303", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[6]
    assert_equal "18050304", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[7]
    assert_equal "18090304", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[8]
    assert_equal "18020101", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[9]
    assert_equal "18050305", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[10]
    assert_equal "18090305", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[11]
    assert_equal "18020102", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[12]
    assert_equal "18050306", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[13]
    assert_equal "18090306", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[14]
    assert_equal "18020103", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[15]
    assert_equal "18050307", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[16]
    assert_equal "18090307", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[17]
    assert_equal "18020104", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[18]
    assert_equal "18050308", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[19]
    assert_equal "18090308", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[20]
    assert_equal "18020105", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[21]
    assert_equal "18030201", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[22]
    assert_equal "18070301", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    # execute - download
    race_list_pages.each { |r| r.download_from_web! }

    # check
    assert_equal 0, RaceListPage.find_all.length

    race_list_pages.each do |race_list_page|
      assert race_list_page.valid?
      assert_not race_list_page.exists?
    end

    # execute - save
    race_list_pages.each { |r| r.save! }

    # check
    assert_equal 23, RaceListPage.find_all.length

    race_list_pages.each do |race_list_page|
      assert race_list_page.exists?
      assert race_list_page.valid?
    end

    # execute - re-instance
    race_list_pages_2 = schedule_page.race_list_pages

    # check
    assert_equal 23, race_list_pages_2.length

    race_list_pages_2.each do |race_list_page_2|
      assert race_list_page_2.exists?
      assert_not race_list_page_2.valid?
    end

    # execute - re-download
    race_list_pages_2.each { |r| r.download_from_s3! }

    # check
    assert_equal 23, race_list_pages_2.length

    race_list_pages_2.each do |race_list_page_2|
      assert race_list_page_2.exists?
      assert race_list_page_2.valid?

      race_list_page = race_list_pages.find { |r| r.race_id == race_list_page_2.race_id }

      assert race_list_page_2.same?(race_list_page)
    end

    # execute - overwrite
    race_list_pages_2.each { |r| r.save! }

    # check
    assert_equal 23, RaceListPage.find_all.length
  end

  test "download: case link skip" do
    # precondition
    schedule_page_html = File.open("test/fixtures/files/schedule.201808.html").read
    schedule_page = SchedulePage.new(2018, 8, schedule_page_html)

    # execute
    race_list_pages = schedule_page.race_list_pages

    # postcondition
    assert_equal 0, RaceListPage.find_all.length

    assert_equal 6, race_list_pages.length

    race_list_page = race_list_pages[0]
    assert_equal "18010103", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[1]
    assert_equal "18040203", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[2]
    assert_equal "18100203", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[3]
    assert_equal "18010104", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[4]
    assert_equal "18040204", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    race_list_page = race_list_pages[5]
    assert_equal "18100204", race_list_page.race_id
    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    # execute - download
    race_list_pages.each { |r| r.download_from_web! }

    # check
    assert_equal 0, RaceListPage.find_all.length

    race_list_pages.each do |race_list_page|
      assert race_list_page.valid?
      assert_not race_list_page.exists?
    end

    # execute - save
    race_list_pages.each { |r| r.save! }

    # check
    assert_equal 6, RaceListPage.find_all.length

    race_list_pages.each do |race_list_page|
      assert race_list_page.exists?
      assert race_list_page.valid?
    end

    # execute - re-instance
    race_list_pages_2 = schedule_page.race_list_pages

    # check
    assert_equal 6, race_list_pages_2.length

    race_list_pages_2.each do |race_list_page_2|
      assert race_list_page_2.exists?
      assert_not race_list_page_2.valid?
    end

    # execute - re-download
    race_list_pages_2.each { |r| r.download_from_s3! }

    # check
    assert_equal 6, race_list_pages_2.length

    race_list_pages_2.each do |race_list_page_2|
      assert race_list_page_2.exists?
      assert race_list_page_2.valid?

      race_list_page = race_list_pages.find { |r| r.race_id == race_list_page_2.race_id }

      assert race_list_page_2.same?(race_list_page)
    end

    # execute - overwrite
    race_list_pages_2.each { |r| r.save! }

    # check
    assert_equal 6, RaceListPage.find_all.length
  end

  test "download: case invalid html" do
    # execute
    race_list_page = RaceListPage.new("00000000")

    # check
    assert_equal 0, RaceListPage.find_all.length

    assert_equal "00000000", race_list_page.race_id
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    # execute
    race_list_page.download_from_web!

    # check
    assert_equal 0, RaceListPage.find_all.length

    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    # execute
    assert_raises "Invalid" do
      race_list_page.save!
    end

    # check
    assert_equal 0, RaceListPage.find_all.length

    assert_not race_list_page.exists?
    assert_not race_list_page.valid?
  end

  test "parse" do
    # setup
    schedule_page_html = File.open("test/fixtures/files/schedule.201806.html").read
    schedule_page = SchedulePage.new(2018, 6, schedule_page_html)

    race_list_page_html = File.open("test/fixtures/files/race_list.20180624.hanshin.html").read

    # execute
    race_list_page = RaceListPage.new("18090308", race_list_page_html)

    # check
    assert_equal "18090308", race_list_page.race_id
    assert_equal Time.zone.local(2018, 6, 24), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert race_list_page.valid?

    assert_equal 12, race_list_page.result_pages.length

    result_page = race_list_page.result_pages[0]
    assert_equal "1809030801", result_page.result_id
    assert_nil result_page.race_number
    assert_nil result_page.race_name
    assert_nil result_page.start_datetime
    assert_nil result_page.entry_page
    assert_nil result_page.odds_win_page
    assert_not result_page.valid?
    assert_not result_page.exists?

    result_page = race_list_page.result_pages[1]
    assert_equal "1809030802", result_page.result_id
    assert_nil result_page.race_number
    assert_nil result_page.race_name
    assert_nil result_page.start_datetime
    assert_nil result_page.entry_page
    assert_nil result_page.odds_win_page
    assert_not result_page.valid?
    assert_not result_page.exists?

    result_page = race_list_page.result_pages[2]
    assert_equal "1809030803", result_page.result_id
    assert_nil result_page.race_number
    assert_nil result_page.race_name
    assert_nil result_page.start_datetime
    assert_nil result_page.entry_page
    assert_nil result_page.odds_win_page
    assert_not result_page.valid?
    assert_not result_page.exists?

    result_page = race_list_page.result_pages[3]
    assert_equal "1809030804", result_page.result_id
    assert_nil result_page.race_number
    assert_nil result_page.race_name
    assert_nil result_page.start_datetime
    assert_nil result_page.entry_page
    assert_nil result_page.odds_win_page
    assert_not result_page.valid?
    assert_not result_page.exists?

    result_page = race_list_page.result_pages[4]
    assert_equal "1809030805", result_page.result_id
    assert_nil result_page.race_number
    assert_nil result_page.race_name
    assert_nil result_page.start_datetime
    assert_nil result_page.entry_page
    assert_nil result_page.odds_win_page
    assert_not result_page.valid?
    assert_not result_page.exists?

    result_page = race_list_page.result_pages[5]
    assert_equal "1809030806", result_page.result_id
    assert_nil result_page.race_number
    assert_nil result_page.race_name
    assert_nil result_page.start_datetime
    assert_nil result_page.entry_page
    assert_nil result_page.odds_win_page
    assert_not result_page.valid?
    assert_not result_page.exists?

    result_page = race_list_page.result_pages[6]
    assert_equal "1809030807", result_page.result_id
    assert_nil result_page.race_number
    assert_nil result_page.race_name
    assert_nil result_page.start_datetime
    assert_nil result_page.entry_page
    assert_nil result_page.odds_win_page
    assert_not result_page.valid?
    assert_not result_page.exists?

    result_page = race_list_page.result_pages[7]
    assert_equal "1809030808", result_page.result_id
    assert_nil result_page.race_number
    assert_nil result_page.race_name
    assert_nil result_page.start_datetime
    assert_nil result_page.entry_page
    assert_nil result_page.odds_win_page
    assert_not result_page.valid?
    assert_not result_page.exists?

    result_page = race_list_page.result_pages[8]
    assert_equal "1809030809", result_page.result_id
    assert_nil result_page.race_number
    assert_nil result_page.race_name
    assert_nil result_page.start_datetime
    assert_nil result_page.entry_page
    assert_nil result_page.odds_win_page
    assert_not result_page.valid?
    assert_not result_page.exists?

    result_page = race_list_page.result_pages[9]
    assert_equal "1809030810", result_page.result_id
    assert_nil result_page.race_number
    assert_nil result_page.race_name
    assert_nil result_page.start_datetime
    assert_nil result_page.entry_page
    assert_nil result_page.odds_win_page
    assert_not result_page.valid?
    assert_not result_page.exists?

    result_page = race_list_page.result_pages[10]
    assert_equal "1809030811", result_page.result_id
    assert_nil result_page.race_number
    assert_nil result_page.race_name
    assert_nil result_page.start_datetime
    assert_nil result_page.entry_page
    assert_nil result_page.odds_win_page
    assert_not result_page.valid?
    assert_not result_page.exists?

    result_page = race_list_page.result_pages[11]
    assert_equal "1809030812", result_page.result_id
    assert_nil result_page.race_number
    assert_nil result_page.race_name
    assert_nil result_page.start_datetime
    assert_nil result_page.entry_page
    assert_nil result_page.odds_win_page
    assert_not result_page.valid?
    assert_not result_page.exists?
  end

  test "parse: case invalid html" do
    # setup
    schedule_page_html = File.open("test/fixtures/files/schedule.201808.html").read
    schedule_page = SchedulePage.new(2018, 8, schedule_page_html)

    # execute
    race_list_page = RaceListPage.new("aaaaaaaaaa", "Invalid html")

    # postcondition
    assert_equal "aaaaaaaaaa", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
  end

  test "save, and overwrite" do
    # setup
    schedule_page_html = File.open("test/fixtures/files/schedule.201806.html").read
    schedule_page = SchedulePage.new(2018, 6, schedule_page_html)

    race_list_page_html = File.open("test/fixtures/files/race_list.20180624.hanshin.html").read

    # execute - インスタンス化 & パース
    race_list_page = RaceListPage.new("18090308", race_list_page_html)

    # check
    assert_equal 0, RaceListPage.find_all.length

    assert_equal "18090308", race_list_page.race_id
    assert_equal Time.zone.local(2018, 6, 24), race_list_page.date
    assert_equal "阪神", race_list_page.course_name
    assert_equal 12, race_list_page.result_pages.length
    assert race_list_page.valid?
    assert_not race_list_page.exists?

    # execute - 保存
    race_list_page.save!

    # check
    assert_equal 1, RaceListPage.find_all.length

    assert race_list_page.valid?
    assert race_list_page.exists?

    # execute - 再ダウンロード
    race_list_page.download_from_web!

    # check
    assert_equal 1, RaceListPage.find_all.length

    assert race_list_page.valid?
    assert race_list_page.exists?

    # execute - 再保存
    race_list_page.save!

    # check
    assert_equal 1, RaceListPage.find_all.length

    assert race_list_page.valid?
    assert race_list_page.exists?
  end

  test "can't save: invalid" do
    # setup
    schedule_page_html = File.open("test/fixtures/files/schedule.201806.html").read
    schedule_page = SchedulePage.new(2018, 6, schedule_page_html)

    # execute - 不正なHTMLをインスタンス化
    race_list_page = RaceListPage.new("aaaaaaaa", "Invalid html")

    # check
    assert_equal 0, RaceListPage.find_all.length

    assert_not race_list_page.valid?
    assert_not race_list_page.exists?

    # execute - 保存しようとして例外がスローされる
    assert_raises "Invalid" do
      race_list_page.save!
    end

    # check
    assert_equal 0, RaceListPage.find_all.length

    assert_not race_list_page.valid?
    assert_not race_list_page.exists?
  end

  test "find" do
    # setup
    schedule_page_html = File.open("test/fixtures/files/schedule.201806.html").read
    schedule_page = SchedulePage.new(2018, 6, schedule_page_html)

    race_list_page_1_html = File.open("test/fixtures/files/race_list.20180603.tokyo.html").read
    race_list_page_1 = RaceListPage.new("18050302", race_list_page_1_html)

    race_list_page_2_html = File.open("test/fixtures/files/race_list.20180624.hanshin.html").read
    race_list_page_2 = RaceListPage.new("18090308", race_list_page_2_html)

    # execute
    race_list_pages = RaceListPage.find_all

    # check - 未保存時は0件
    assert_equal 0, race_list_pages.length

    # setup
    schedule_page.save!
    race_list_page_1.save!
    race_list_page_2.save!

    # execute
    race_list_pages = RaceListPage.find_all

    race_list_pages.each { |r| r.download_from_s3! }

    # check
    assert_equal 2, race_list_pages.length

    assert race_list_pages[0].same?(race_list_page_1)
    assert race_list_pages[1].same?(race_list_page_2)
  end

end
