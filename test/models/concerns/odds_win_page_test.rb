require 'test_helper'

class OddsWinPageTest < ActiveSupport::TestCase

  def setup
    @bucket = NetModule.get_s3_bucket
    @bucket.objects.batch_delete!
  end

  test "download" do
    # setup
    result_html = File.open("test/fixtures/files/result.20180624.hanshin.1.html").read
    result_page = ResultPage.new("1809030801", result_html)

    # execute - インスタンス化
    odds_win_page = result_page.odds_win_page

    # check
    assert_equal 0, OddsWinPage.find_all.length

    assert_equal "1809030801", odds_win_page.odds_id
    assert_nil odds_win_page.win_results
    assert_nil odds_win_page.place_results
    assert_nil odds_win_page.bracket_quinella_results
    assert_not odds_win_page.valid?
    assert_not odds_win_page.exists?

    # execute - ダウンロード
    odds_win_page.download_from_web!

    # check
    assert_equal 0, OddsWinPage.find_all.length

    assert_equal "1809030801", odds_win_page.odds_id
    assert_not_nil odds_win_page.win_results # FIXME
    assert_not_nil odds_win_page.place_results # FIXME
    assert_not_nil odds_win_page.bracket_quinella_results # FIXME
    assert odds_win_page.valid?
    assert_not odds_win_page.exists?

    # execute - 保存
    odds_win_page.save!

    # check
    assert_equal 1, OddsWinPage.find_all.length

    assert odds_win_page.valid?
    assert odds_win_page.exists?

    # execute - 再インスタンス化
    result_page = ResultPage.new("1809030801", result_html)
    odds_win_page_2 = result_page.odds_win_page

    # check
    assert_equal 1, OddsWinPage.find_all.length

    assert_equal "1809030801", odds_win_page_2.odds_id
    assert_nil odds_win_page_2.win_results
    assert_nil odds_win_page_2.place_results
    assert_nil odds_win_page_2.bracket_quinella_results
    assert_not odds_win_page_2.valid?
    assert odds_win_page_2.exists?

    # execute - 再ダウンロード
    odds_win_page_2.download_from_s3!

    # check
    assert_equal 1, OddsWinPage.find_all.length

    assert_equal "1809030801", odds_win_page_2.odds_id
    assert_not_nil odds_win_page_2.win_results
    assert_not_nil odds_win_page_2.place_results
    assert_not_nil odds_win_page_2.bracket_quinella_results
    assert odds_win_page_2.valid?
    assert odds_win_page_2.exists?

    # execute - 上書き保存
    odds_win_page_2.save!

    # check
    assert_equal 1, OddsWinPage.find_all.length
  end

  test "download: case invalid html" do
    # execute - 不正なHTMLをインスタンス化
    odds_win_page = OddsWinPage.new("0000000000", "Invalid html")

    # check
    assert_equal 0, OddsWinPage.find_all.length

    assert_equal "0000000000", odds_win_page.odds_id
    assert_not odds_win_page.valid?
    assert_not odds_win_page.exists?

    # execute - ダウンロード -> 失敗
    odds_win_page.download_from_web!

    # check
    assert_equal 0, OddsWinPage.find_all.length

    assert_equal "0000000000", odds_win_page.odds_id
    assert_not odds_win_page.valid?
    assert_not odds_win_page.exists?

    # execute - 保存 -> 失敗
    assert_raises "Invalid" do
      odds_win_page.save!
    end

    # check
    assert_equal 0, OddsWinPage.find_all.length

    assert_equal "0000000000", odds_win_page.odds_id
    assert_not odds_win_page.valid?
    assert_not odds_win_page.exists?
  end

  test "parse" do
    # setup
    odds_win_page_html = File.open("test/fixtures/files/odds_win.20180624.hanshin.html").read

    # execute
    odds_win_page = OddsWinPage.new("1809030801", odds_win_page_html)

    # check
    assert_equal "1809030801", odds_win_page.odds_id
    assert_not_nil odds_win_page.win_results # FIXME
    assert_not_nil odds_win_page.place_results # FIXME
    assert_not_nil odds_win_page.bracket_quinella_results # FIXME
    assert odds_win_page.valid?
    assert_not odds_win_page.exists?
  end

  test "parse: invalid html" do
    # execute
    odds_win_page = OddsWinPage.new("0000000000", "Invalid html")

    # check
    assert_equal "0000000000", odds_win_page.odds_id
    assert_nil odds_win_page.win_results
    assert_nil odds_win_page.place_results
    assert_nil odds_win_page.bracket_quinella_results
    assert_not odds_win_page.valid?
    assert_not odds_win_page.exists?
  end

end
