require 'test_helper'

class OddsTrioPageTest < ActiveSupport::TestCase

  def setup
    @bucket = NetModule.get_s3_bucket
    @bucket.objects.batch_delete!
  end

  test "download" do
    # setup
    odds_win_page_html = File.open("test/fixtures/files/odds_win.20180624.hanshin.1.html").read
    odds_win_page = OddsWinPage.new("1809030801", odds_win_page_html)

    # execute - new
    odds_trio_page = odds_win_page.odds_trio_page

    # check
    assert_equal 0, OddsTrioPage.find_all.length

    assert_equal "1809030801", odds_trio_page.odds_id
    assert_nil odds_trio_page.trio_results
    assert_not odds_trio_page.valid?
    assert_not odds_trio_page.exists?

    # execute - download
    odds_trio_page.download_from_web!

    # check
    assert_equal 0, OddsTrioPage.find_all.length

    assert_equal "1809030801", odds_trio_page.odds_id
    assert_not_nil odds_trio_page.trio_results # FIXME
    assert odds_trio_page.valid?
    assert_not odds_trio_page.exists?

    # execute - save
    odds_trio_page.save!

    # check
    assert_equal 1, OddsTrioPage.find_all.length

    assert odds_trio_page.valid?
    assert odds_trio_page.exists?

    # execute - re-new
    odds_win_page = OddsWinPage.new("1809030801", odds_win_page_html)
    odds_trio_page_2 = odds_win_page.odds_trio_page

    # check
    assert_equal 1, OddsTrioPage.find_all.length

    assert_equal "1809030801", odds_trio_page_2.odds_id
    assert_nil odds_trio_page_2.trio_results
    assert_not odds_trio_page_2.valid?
    assert odds_trio_page_2.exists?

    # execute - download
    odds_trio_page_2.download_from_s3!

    # check
    assert_equal 1, OddsTrioPage.find_all.length

    assert odds_trio_page_2.valid?
    assert odds_trio_page_2.exists?

    # execute - overwrite
    odds_trio_page_2.save!

    # check
    assert_equal 1, OddsTrioPage.find_all.length
  end

  test "download: invalid html" do
    # execute - new from invalid html
    odds_trio_page = OddsTrioPage.new("0000000000", "Invalid html")

    # check
    assert_equal 0, OddsTrioPage.find_all.length

    assert_equal "0000000000", odds_trio_page.odds_id
    assert_not odds_trio_page.valid?
    assert_not odds_trio_page.exists?

    # execute - download -> fail
    odds_trio_page.download_from_web!

    # check
    assert_equal 0, OddsTrioPage.find_all.length

    assert_not odds_trio_page.valid?
    assert_not odds_trio_page.exists?

    # execute - save -> fail
    assert_raises "Invalid" do
      odds_trio_page.save!
    end

    # check
    assert_equal 0, OddsTrioPage.find_all.length

    assert_not odds_trio_page.valid?
    assert_not odds_trio_page.exists?
  end

  test "parse" do
    # setup
    odds_trio_page_html = File.open("test/fixtures/files/odds_trio.20180624.hanshin.1.html").read

    # execute
    odds_trio_page = OddsTrioPage.new("1809030801", odds_trio_page_html)

    # check
    assert_equal 0, OddsTrioPage.find_all.length

    assert_equal "1809030801", odds_trio_page.odds_id
    assert_not_nil odds_trio_page.trio_results # FIXME
    assert odds_trio_page.valid?
    assert_not odds_trio_page.exists?
  end

  test "parse: invalid html" do
    # execute
    odds_trio_page = OddsTrioPage.new("0000000000", "Invalid html")

    # check
    assert_equal 0, OddsTrioPage.find_all.length

    assert_equal "0000000000", odds_trio_page.odds_id
    assert_nil odds_trio_page.trio_results
    assert_not odds_trio_page.valid?
    assert_not odds_trio_page.exists?
  end

  test "save, and overwrite" do
    # setup
    odds_trio_page_html = File.open("test/fixtures/files/odds_trio.20180624.hanshin.1.html").read

    # execute
    odds_trio_page = OddsTrioPage.new("1809030801", odds_trio_page_html)

    # check
    assert_equal 0, OddsTrioPage.find_all.length

    assert_equal "1809030801", odds_trio_page.odds_id
    assert_not_nil odds_trio_page.trio_results # FIXME
    assert odds_trio_page.valid?
    assert_not odds_trio_page.exists?

    # execute - save
    odds_trio_page.save!

    # check
    assert_equal 1, OddsTrioPage.find_all.length

    assert odds_trio_page.valid?
    assert odds_trio_page.exists?

    # execute - re-download
    odds_trio_page.download_from_web!

    # check
    assert_equal 1, OddsTrioPage.find_all.length

    assert odds_trio_page.valid?
    assert odds_trio_page.exists?

    # execute - re-save
    odds_trio_page.save!

    # check
    assert_equal 1, OddsTrioPage.find_all.length

    assert odds_trio_page.valid?
    assert odds_trio_page.exists?
  end

  test "save: invalid" do
    # execute - new invalid html
    odds_trio_page = OddsTrioPage.new("0000000000", "Invalid html")

    # check
    assert_equal 0, OddsTrioPage.find_all.length

    assert_not odds_trio_page.valid?
    assert_not odds_trio_page.exists?

    # execute - raised exception when save
    assert_raises "Invalid" do
      odds_trio_page.save!
    end

    # check
    assert_equal 0, OddsTrioPage.find_all.length

    assert_not odds_trio_page.valid?
    assert_not odds_trio_page.exists?
  end

  test "find" do
    # setup
    odds_trio_page_1_html = File.open("test/fixtures/files/odds_trio.20180624.hanshin.1.html").read
    odds_trio_page_1 = OddsTrioPage.new("1809030801", odds_trio_page_1_html)

    odds_trio_page_2_html = File.open("test/fixtures/files/odds_trio.20180624.hanshin.2.html").read
    odds_trio_page_2 = OddsTrioPage.new("1809030802", odds_trio_page_2_html)

    odds_trio_page_3_html = File.open("test/fixtures/files/odds_trio.20180624.hanshin.3.html").read
    odds_trio_page_3 = OddsTrioPage.new("1809030803", odds_trio_page_3_html)

    # check
    assert_equal 0, OddsTrioPage.find_all.length

    # setup
    odds_trio_page_1.save!
    odds_trio_page_2.save!
    odds_trio_page_3.save!

    # execute
    odds_trio_pages = OddsTrioPage.find_all

    odds_trio_pages.each { |o| o.download_from_s3! }

    # check
    assert_equal 3, odds_trio_pages.length

    assert odds_trio_page_1.same?(odds_trio_pages.find { |o| o.odds_id == odds_trio_page_1.odds_id })
    assert odds_trio_page_2.same?(odds_trio_pages.find { |o| o.odds_id == odds_trio_page_2.odds_id })
    assert odds_trio_page_3.same?(odds_trio_pages.find { |o| o.odds_id == odds_trio_page_3.odds_id })
  end

end

