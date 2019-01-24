require 'test_helper'

class OddsExactaPageTest < ActiveSupport::TestCase

  def setup
    repo = build_resource_repository
    repo.remove_s3_objects
  end

  test "download" do
    # setup
    odds_win_page_html = File.open("test/fixtures/files/odds_win.20180624.hanshin.1.html").read
    odds_win_page = OddsWinPage.new("1809030801", odds_win_page_html)

    # execute - new
    odds_exacta_page = odds_win_page.odds_exacta_page

    # check
    assert_equal "1809030801", odds_exacta_page.odds_id
    assert_nil odds_exacta_page.exacta_results
    assert_not odds_exacta_page.valid?
    assert_not odds_exacta_page.exists?

    # execute - download
    odds_exacta_page.download_from_web!

    # check
    assert_equal "1809030801", odds_exacta_page.odds_id
    assert_not_nil odds_exacta_page.exacta_results # FIXME
    assert odds_exacta_page.valid?
    assert_not odds_exacta_page.exists?

    # execute - save
    odds_exacta_page.save!

    # check
    assert odds_exacta_page.valid?
    assert odds_exacta_page.exists?

    # execute - re-new
    odds_win_page = OddsWinPage.new("1809030801", odds_win_page_html)
    odds_exacta_page_2 = odds_win_page.odds_exacta_page

    # check
    assert_equal "1809030801", odds_exacta_page_2.odds_id
    assert_nil odds_exacta_page_2.exacta_results
    assert_not odds_exacta_page_2.valid?
    assert odds_exacta_page_2.exists?

    # execute - download
    odds_exacta_page_2.download_from_s3!

    # check
    assert odds_exacta_page_2.valid?
    assert odds_exacta_page_2.exists?

    # execute - overwrite
    odds_exacta_page_2.save!
  end

  test "download: invalid html" do
    # execute - new from invalid html
    odds_exacta_page = OddsExactaPage.new("0000000000", "Invalid html")

    # check
    assert_equal "0000000000", odds_exacta_page.odds_id
    assert_not odds_exacta_page.valid?
    assert_not odds_exacta_page.exists?

    # execute - download -> fail
    odds_exacta_page.download_from_web!

    # check
    assert_not odds_exacta_page.valid?
    assert_not odds_exacta_page.exists?

    # execute - save -> fail
    assert_raises "Invalid" do
      odds_exacta_page.save!
    end

    # check
    assert_not odds_exacta_page.valid?
    assert_not odds_exacta_page.exists?
  end

  test "parse" do
    # setup
    odds_exacta_page_html = File.open("test/fixtures/files/odds_exacta.20180624.hanshin.1.html").read

    # execute
    odds_exacta_page = OddsExactaPage.new("1809030801", odds_exacta_page_html)

    # check
    assert_equal "1809030801", odds_exacta_page.odds_id
    assert_not_nil odds_exacta_page.exacta_results # FIXME
    assert odds_exacta_page.valid?
    assert_not odds_exacta_page.exists?
  end

  test "parse: invalid html" do
    # execute
    odds_exacta_page = OddsExactaPage.new("0000000000", "Invalid html")

    # check
    assert_equal "0000000000", odds_exacta_page.odds_id
    assert_nil odds_exacta_page.exacta_results
    assert_not odds_exacta_page.valid?
    assert_not odds_exacta_page.exists?
  end

  test "save, and overwrite" do
    # setup
    odds_exacta_page_html = File.open("test/fixtures/files/odds_exacta.20180624.hanshin.1.html").read

    # execute
    odds_exacta_page = OddsExactaPage.new("1809030801", odds_exacta_page_html)

    # check
    assert_equal "1809030801", odds_exacta_page.odds_id
    assert_not_nil odds_exacta_page.exacta_results # FIXME
    assert odds_exacta_page.valid?
    assert_not odds_exacta_page.exists?

    # execute - save
    odds_exacta_page.save!

    # check
    assert odds_exacta_page.valid?
    assert odds_exacta_page.exists?

    # execute - re-download
    odds_exacta_page.download_from_web!

    # check
    assert odds_exacta_page.valid?
    assert odds_exacta_page.exists?

    # execute - re-save
    odds_exacta_page.save!

    # check
    assert odds_exacta_page.valid?
    assert odds_exacta_page.exists?
  end

  test "save: invalid" do
    # execute - new invalid html
    odds_exacta_page = OddsExactaPage.new("0000000000", "Invalid html")

    # check
    assert_not odds_exacta_page.valid?
    assert_not odds_exacta_page.exists?

    # execute - raised exception when save
    assert_raises "Invalid" do
      odds_exacta_page.save!
    end

    # check
    assert_not odds_exacta_page.valid?
    assert_not odds_exacta_page.exists?
  end

end

