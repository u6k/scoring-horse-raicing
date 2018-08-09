require 'test_helper'

class ResultPageTest < ActiveSupport::TestCase

  def setup
    @bucket = NetModule.get_s3_bucket
    @bucket.objects.batch_delete!
  end

  test "download" do
    # setup
    schedule_page_html = File.open("test/fixtures/files/schedule.201806.html").read
    schedule_page = SchedulePage.new(2018, 6, schedule_page_html)

    race_list_page_html = File.open("test/fixtures/files/race_list.20180624.hanshin.html").read
    race_list_page = RaceListPage.new("18090308", race_list_page_html)

    # execute - インスタンス化
    result_pages = race_list_page.result_pages

    # check
    assert_equal 0, ResultPage.find_all.length

    assert_equal 12, result_pages.length

    assert_equal "1809030801", result_pages[0].result_id
    assert_equal "1809030802", result_pages[1].result_id
    assert_equal "1809030803", result_pages[2].result_id
    assert_equal "1809030804", result_pages[3].result_id
    assert_equal "1809030805", result_pages[4].result_id
    assert_equal "1809030806", result_pages[5].result_id
    assert_equal "1809030807", result_pages[6].result_id
    assert_equal "1809030808", result_pages[7].result_id
    assert_equal "1809030809", result_pages[8].result_id
    assert_equal "1809030810", result_pages[9].result_id
    assert_equal "1809030811", result_pages[10].result_id
    assert_equal "1809030812", result_pages[11].result_id

    result_pages.each do |result_page|
      assert_nil result_page.race_number
      assert_nil result_page.race_name
      assert_nil result_page.start_datetime
      assert_nil result_page.entry_page
      assert_nil result_page.odds_win_page
      assert_not result_page.valid?
      assert_not result_page.exists?
    end

    # execute - ダウンロード
    result_pages.each { |r| r.download_from_web! }

    # check
    assert_equal 0, ResultPage.find_all.length

    assert_equal 12, result_pages.length

    result_page = result_pages[0]
    assert_equal "1809030801", result_page.result_id
    assert_equal 1, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 24, 10, 5, 0), result_page.start_datetime
    assert_equal "サラ系3歳未勝利", result_page.race_name

    result_page = result_pages[1]
    assert_equal "1809030802", result_page.result_id
    assert_equal 2, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 24, 10, 35, 0), result_page.start_datetime
    assert_equal "サラ系3歳未勝利", result_page.race_name

    result_page = result_pages[2]
    assert_equal "1809030803", result_page.result_id
    assert_equal 3, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 24, 11, 5, 0), result_page.start_datetime
    assert_equal "サラ系3歳未勝利", result_page.race_name

    result_page = result_pages[3]
    assert_equal "1809030804", result_page.result_id
    assert_equal 4, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 24, 11, 35, 0), result_page.start_datetime
    assert_equal "サラ系3歳未勝利", result_page.race_name

    result_page = result_pages[4]
    assert_equal "1809030805", result_page.result_id
    assert_equal 5, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 24, 12, 25, 0), result_page.start_datetime
    assert_equal "サラ系2歳新馬", result_page.race_name

    result_page = result_pages[5]
    assert_equal "1809030806", result_page.result_id
    assert_equal 6, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 24, 12, 55, 0), result_page.start_datetime
    assert_equal "サラ系3歳上500万円以下", result_page.race_name

    result_page = result_pages[6]
    assert_equal "1809030807", result_page.result_id
    assert_equal 7, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 24, 13, 25, 0), result_page.start_datetime
    assert_equal "サラ系3歳上500万円以下", result_page.race_name

    result_page = result_pages[7]
    assert_equal "1809030808", result_page.result_id
    assert_equal 8, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 24, 13, 55, 0), result_page.start_datetime
    assert_equal "出石特別", result_page.race_name

    result_page = result_pages[8]
    assert_equal "1809030809", result_page.result_id
    assert_equal 9, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 24, 14, 25, 0), result_page.start_datetime
    assert_equal "皆生特別", result_page.race_name

    result_page = result_pages[9]
    assert_equal "1809030810", result_page.result_id
    assert_equal 10, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 24, 15, 1, 0), result_page.start_datetime
    assert_equal "花のみちステークス", result_page.race_name

    result_page = result_pages[10]
    assert_equal "1809030811", result_page.result_id
    assert_equal 11, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 24, 15, 40, 0), result_page.start_datetime
    assert_equal "宝塚記念（GI）", result_page.race_name

    result_page = result_pages[11]
    assert_equal "1809030812", result_page.result_id
    assert_equal 12, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 24, 16, 30, 0), result_page.start_datetime
    assert_equal "リボン賞", result_page.race_name

    result_pages.each do |result_page|
      assert result_page.valid?
      assert_not result_page.exists?
    end

    # execute - 保存
    result_pages.each { |r| r.save! }

    # check
    assert_equal 12, ResultPage.find_all.length

    result_pages.each do |result_page|
      assert result_page.valid?
      assert result_page.exists?
    end

    # execute - 再インスタンス化
    schedule_page = SchedulePage.new(2018, 6, schedule_page_html)
    race_list_page = RaceListPage.download("18090308", race_list_page_html)
    result_pages_2 = race_list_page.result_pages

    # check
    assert_equal 12, ResultPage.find_all.length

    assert_equal 12, result_pages_2.length

    assert_equal "1809030801", result_pages_2[0].result_id
    assert_equal "1809030802", result_pages_2[1].result_id
    assert_equal "1809030803", result_pages_2[2].result_id
    assert_equal "1809030804", result_pages_2[3].result_id
    assert_equal "1809030805", result_pages_2[4].result_id
    assert_equal "1809030806", result_pages_2[5].result_id
    assert_equal "1809030807", result_pages_2[6].result_id
    assert_equal "1809030808", result_pages_2[7].result_id
    assert_equal "1809030809", result_pages_2[8].result_id
    assert_equal "1809030810", result_pages_2[9].result_id
    assert_equal "1809030811", result_pages_2[10].result_id
    assert_equal "1809030812", result_pages[11].result_id

    result_pages_2.each do |result_page_2|
      assert_nil result_page_2.race_number
      assert_nil result_page_2.race_name
      assert_nil result_page_2.start_datetime
      assert_nil result_page_2.entry_page
      assert_nil result_page_2.odds_win_page
      assert_not result_page_2.valid?
      assert result_page_2.exists?
    end

    # execute - 再ダウンロード
    result_pages_2.each { |r| r.download_from_s3! }

    # check
    result_pages_2.each do |result_page_2|
      assert result_page_2.valid?
      assert result_page_2.exists?

      result_page = result_pages.find { |r| r.result_id == result_page_2.result_id }
      result_page_2.same?(result_page)
    end

    # execute - 上書き保存
    result_pages_2.each { |r| r.save! }

    # check
    assert_equal 12, ResultPage.find_all.length
  end

  test "download: case invalid html" do
    # execute - 不正なレースIDのページをインスタンス化
    result_page = ResultPage.new("0000000000")

    # check
    assert_equal 0, ResultPage.find_all.length

    assert_equal "0000000000", result_page.result_id
    assert_not result_page.valid?
    assert_not result_page.exists?

    # execute - ダウンロード -> 失敗
    result_page.download_from_web!

    # check
    assert_equal 0, ResultPage.find_all.length

    assert_equal "0000000000", result_page.result_id
    assert_not result_page.valid?
    assert_not result_page.exists?

    # execute - 保存 -> 失敗
    assert_raises "Invalid" do
      result_page.save!
    end

    # check
    assert_equal 0, ResultPage.find_all.length

    assert_equal "0000000000", result_page.result_id
    assert_not result_page.valid?
    assert_not result_page.exists?
  end

  test "parse" do
    # setup
    result_html = File.open("test/fixtures/files/result.20180624.hanshin.html").read

    # execute
    result_page = ResultPage.new("1809030801", result_html)

    # check
    assert_equal "1809030801", result_page.result_id
    assert_equal 1, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 24, 10, 5, 0), result_page.start_datetime
    assert_equal "サラ系3歳未勝利", result_page.race_name
    assert_equal "1809030801", result_page.entry_page.entry_id
    assert_equal "1809030801", result_page.odds_win_page.odds_win_id
    assert result_page.valid?
    assert_not result_page.exists?
  end

  test "parse: missing link" do
    # setup
    result_html = File.open("test/fixtures/files/result.19860126.tyukyou.11.html").read

    # execute
    result_page = ResultPage.new("8607010211", result_html)

    # check
    assert_equal "8607010211", result_page.result_id
    assert_equal 11, result_page.race_number
    assert_equal Time.zone.local(1986, 1, 26, 15, 35, 0), result_page.start_datetime
    assert_equal "中京スポーツ杯", result_page.race_name
    assert_nil result_page.entry_page
    assert_nil result_page.odds_win_page
    assert result_page.valid?
    assert_not result_page.exists?
  end

  test "parse: case invalid html" do
    # execute
    result_page = ResultPage.new("0000000000")
    result_page.download_from_web!

    # check
    assert_equal "0000000000", result_page.result_id
    assert_nil result_page.race_number
    assert_nil result_page.start_datetime
    assert_nil result_page.race_name
    assert_nil result_page.entry_page
    assert_nil result_page.odds_win_page
    assert_not result_page.valid?
    assert_not result_page.exists?
  end

  test "save, and overwrite" do
    # setup
    result_html = File.open("test/fixtures/files/result.20180624.hanshin.html").read

    # execute
    result_page = ResultPage.new("1809030801", result_html)

    # check
    assert_equal 0, ResultPage.find_all.length

    assert_equal "1809030801", result_page.result_id
    assert_equal 1, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 24, 10, 5, 0), result_page.start_datetime
    assert_equal "サラ系3歳未勝利", result_page.race_name
    assert_equal "1809030801", result_page.entry_page.entry_id
    assert_equal "1809030801", result_page.odds_win_page.odds_win_id
    assert result_page.valid?
    assert_not result_page.exists?

    # execute - 保存
    result_page.save!

    # check
    assert_equal 1, ResultPage.find_all.length

    assert result_page.valid?
    assert result_page.exists?

    # execute - 再ダウンロード
    result_page.download_from_web!

    # check
    assert_equal 1, ResultPage.find_all.length

    assert result_page.valid?
    assert result_page.exists?

    # execute - 再保存
    result_page.save!

    # check
    assert_equal 1, ResultPage.find_all.length

    assert result_page.valid?
    assert result_page.exists?
  end

  test "can't save: invalid" do
    # execute - 不正なHTMLをインスタンス化
    result_page = ResultPage.new("0000000000", "Invalid html")

    # check
    assert_equal 0, ResultPage.find_all.length

    assert_not result_page.valid?
    assert_not result_page.exists?

    # execute - 保存しようとして例外がスローされる
    assert_raises "Invalid" do
      result_page.save!
    end

    # check
    assert_equal 0, ResultPage.find_all.length

    assert_not result_page.valid?
    assert_not result_page.exists?
  end

  test "find" do
    # setup
    result_page_1_html = File.open("test/fixtures/files/result.19860126.tyukyou.11.html").read
    result_page_1 = ResultPage.new("19860126.tyukyou.11", result_page_1_html)

    result_page_2_html = File.open("test/fixtures/files/result.20180624.hanshin.1.html").read
    result_page_2 = ResultPage.new("20180624.hanshin.1", result_page_2_html)

    result_page_3_html = File.open("test/fixtures/files/result.20180624.tokyo.10.html").read
    result_page_3 = ResultPage.new("20180624.tokyo.10", result_page_3_html)

    result_page_4_html = File.open("test/fixtures/files/result.20180728.kokura.1.html").read
    result_page_4 = ResultPage.new("20180728.kokura.1", result_page_4_html)

    # execute
    result_pages = ResultPage.find_all

    # check - 未保存時は0件
    assert_equal 0, result_pages.length

    # setup
    result_page_1.save!
    result_page_2.save!
    result_page_3.save!
    result_page_4.save!

    # execute
    result_pages = ResultPage.find_all

    result_pages.each { |r| r.download_from_s3!}

    # check
    assert_equal 4, result_pages.length

    assert result_pages[0].same?(result_page_1)
    assert result_pages[1].same?(result_page_2)
    assert result_pages[2].same?(result_page_3)
    assert result_pages[3].same?(result_page_4)
  end

end
