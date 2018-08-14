require 'test_helper'

class OddsTrifectaPageTest < ActiveSupport::TestCase

  def setup
    @bucket = NetModule.get_s3_bucket
    @bucket.objects.batch_delete!
  end

  test "download" do
    # setup
    odds_win_page_html = File.open("test/fixtures/files/odds_win.20180624.hanshin.1.html").read
    odds_win_page = OddsWinPage.new("1809030801", odds_win_page_html)

    # execute - new
    odds_trifecta_page = odds_win_page.odds_trifecta_page

    # check
    assert_equal 0, OddsTrifectaPage.find_all.length

    assert_equal "1809030801", odds_trifecta_page.odds_id
    assert_equal 1, odds_trifecta_page.horse_number
    assert_nil odds_trifecta_page.trifecta_results
    assert_nil odds_trifecta_page.odds_trifecta_pages
    assert_not odds_trifecta_page.valid?
    assert_not odds_trifecta_page.exists?

    # execute - download
    odds_trifecta_page.download_from_web!

    # check
    assert_equal 0, OddsTrifectaPage.find_all.length

    assert_equal "1809030801", odds_trifecta_page.odds_id
    assert_equal 1, odds_trifecta_page.horse_number
    assert_not_nil odds_trifecta_page.trifecta_results # FIXME
    assert_equal 16, odds_trifecta_page.odds_trifecta_pages.length
    assert odds_trifecta_page.valid?
    assert_not odds_trifecta_page.exists?

    # execute - save
    odds_trifecta_page.save!

    # check
    assert_equal 1, OddsTrifectaPage.find_all.length

    assert odds_trifecta_page.valid?
    assert odds_trifecta_page.exists?

    # execute - re-new
    odds_win_page = OddsWinPage.new("1809030801", odds_win_page_html)
    odds_trifecta_page_2 = odds_win_page.odds_trifecta_page

    # check
    assert_equal 1, OddsTrifectaPage.find_all.length

    assert_equal "1809030801", odds_trifecta_page_2.odds_id
    assert_equal 1, odds_trifecta_page_2.horse_number
    assert_nil odds_trifecta_page_2.trifecta_results
    assert_nil odds_trifecta_page_2.odds_trifecta_pages
    assert_not odds_trifecta_page_2.valid?
    assert odds_trifecta_page_2.exists?

    # execute - download
    odds_trifecta_page_2.download_from_s3!

    # check
    assert_equal 1, OddsTrifectaPage.find_all.length

    assert_equal "1809030801", odds_trifecta_page_2.odds_id
    assert_equal 1, odds_trifecta_page_2.horse_number
    assert_not_nil odds_trifecta_page_2.trifecta_results
    assert_equal 16, odds_trifecta_page_2.odds_trifecta_pages.length
    assert odds_trifecta_page_2.valid?
    assert odds_trifecta_page_2.exists?

    # execute - overwrite
    odds_trifecta_page_2.save!

    # check
    assert_equal 1, OddsTrifectaPage.find_all.length
  end

  test "download: invalid html" do
    # execute - new from invalid html
    odds_trifecta_page = OddsTrifectaPage.new("0000000000", nil, "Invalid html")

    # check
    assert_equal 0, OddsTrifectaPage.find_all.length

    assert_equal "0000000000", odds_trifecta_page.odds_id
    assert_equal 1, odds_trifecta_page.horse_number
    assert_not odds_trifecta_page.valid?
    assert_not odds_trifecta_page.exists?

    # execute - download -> fail
    odds_trifecta_page.download_from_web!

    # check
    assert_equal 0, OddsTrifectaPage.find_all.length

    assert_not odds_trifecta_page.valid?
    assert_not odds_trifecta_page.exists?

    # execute - save -> fail
    assert_raises "Invalid" do
      odds_trifecta_page.save!
    end

    # check
    assert_equal 0, OddsTrifectaPage.find_all.length

    assert_not odds_trifecta_page.valid?
    assert_not odds_trifecta_page.exists?
  end

  test "parse" do
    # setup
    odds_trifecta_page_html = File.open("test/fixtures/files/odds_trifecta.20180624.hanshin.1.1.html").read

    # execute
    odds_trifecta_page = OddsTrifectaPage.new("1809030801", nil, odds_trifecta_page_html)

    # check
    assert_equal 0, OddsTrifectaPage.find_all.length

    assert_equal "1809030801", odds_trifecta_page.odds_id
    assert_equal 1, odds_trifecta_page.horse_number
    assert_not_nil odds_trifecta_page.trifecta_results # FIXME
    assert odds_trifecta_page.valid?
    assert_not odds_trifecta_page.exists?

    assert_equal 16, odds_trifecta_page.odds_trifecta_pages.length

    (1..16).each do |horse_number|
      odds_trifecta_sub_page = odds_trifecta_page.odds_trifecta_pages[horse_number]

      assert_equal "1809030801", odds_trifecta_sub_page.odds_id
      assert_equal horse_number, odds_trifecta_sub_page.horse_number
      assert_nil odds_trifecta_sub_page.trifecta_results
      assert_nil odds_trifecta_sub_page.odds_trifecta_pages
      assert_not odds_trifecta_sub_page.valid?
      assert_not odds_trifecta_sub_page.exists?
    end
  end

  test "parse: invalid html" do
    # execute
    odds_trifecta_page = OddsTrifectaPage.new("0000000000", nil, "Invalid html")

    # check
    assert_equal 0, OddsTrifectaPage.find_all.length

    assert_equal "0000000000", odds_trifecta_page.odds_id
    assert_equal 1, odds_trifecta_page.horse_number
    assert_nil odds_trifecta_page.trifecta_results
    assert_nil odds_trifecta_page.odds_trifecta_pages
    assert_not odds_trifecta_page.valid?
    assert_not odds_trifecta_page.exists?
  end

  test "save, and overwrite" do
    # setup
    odds_trifecta_page_html = File.open("test/fixtures/files/odds_trifecta.20180624.hanshin.1.1.html").read

    # execute
    odds_trifecta_page = OddsTrifectaPage.new("1809030801", nil, odds_trifecta_page_html)

    # check
    assert_equal 0, OddsTrifectaPage.find_all.length

    assert_equal "1809030801", odds_trifecta_page.odds_id
    assert_equal 1, odds_trifecta_page.horse_number
    assert_not_nil odds_trifecta_page.trifecta_results # FIXME
    assert_equal 16, odds_trifecta_page.odds_trifecta_pages.length
    assert odds_trifecta_page.valid?
    assert_not odds_trifecta_page.exists?

    # execute - save
    odds_trifecta_page.save!

    # check
    assert_equal 1, OddsTrifectaPage.find_all.length

    assert odds_trifecta_page.valid?
    assert odds_trifecta_page.exists?

    # execute - re-download
    odds_trifecta_page.download_from_web!

    # check
    assert_equal 1, OddsTrifectaPage.find_all.length

    assert odds_trifecta_page.valid?
    assert odds_trifecta_page.exists?

    # execute - re-save
    odds_trifecta_page.save!

    # check
    assert_equal 1, OddsTrifectaPage.find_all.length

    assert odds_trifecta_page.valid?
    assert odds_trifecta_page.exists?
  end

  test "save: invalid" do
    # execute - new invalid html
    odds_trifecta_page = OddsTrifectaPage.new("0000000000", "Invalid html")

    # check
    assert_equal 0, OddsTrifectaPage.find_all.length

    assert_not odds_trifecta_page.valid?
    assert_not odds_trifecta_page.exists?

    # execute - raised exception when save
    assert_raises "Invalid" do
      odds_trifecta_page.save!
    end

    # check
    assert_equal 0, OddsTrifectaPage.find_all.length

    assert_not odds_trifecta_page.valid?
    assert_not odds_trifecta_page.exists?
  end

  test "find" do
    # setup
    odds_trifecta_page_1_html = File.open("test/fixtures/files/odds_trifecta.20180624.hanshin.1.1.html").read
    odds_trifecta_page_1 = OddsTrifectaPage.new("1809030801", nil, odds_trifecta_page_1_html)

    odds_trifecta_page_2_html = File.open("test/fixtures/files/odds_trifecta.20180624.hanshin.2.1.html").read
    odds_trifecta_page_2 = OddsTrifectaPage.new("1809030802", nil, odds_trifecta_page_2_html)

    odds_trifecta_page_3_html = File.open("test/fixtures/files/odds_trifecta.20180624.hanshin.3.1.html").read
    odds_trifecta_page_3 = OddsTrifectaPage.new("1809030803", nil, odds_trifecta_page_3_html)

    # check
    assert_equal 0, OddsTrifectaPage.find_all.length

    # setup
    odds_trifecta_page_1.save!
    odds_trifecta_page_2.save!
    odds_trifecta_page_3.save!

    # execute
    odds_trifecta_pages = OddsTrifectaPage.find_all

    odds_trifecta_pages.each { |o| o.download_from_s3! }

    # check
    assert_equal 3, odds_trifecta_pages.length

    assert odds_trifecta_page_1.same?(odds_trifecta_pages.find { |o| o.odds_id == odds_trifecta_page_1.odds_id })
    assert odds_trifecta_page_2.same?(odds_trifecta_pages.find { |o| o.odds_id == odds_trifecta_page_2.odds_id })
    assert odds_trifecta_page_3.same?(odds_trifecta_pages.find { |o| o.odds_id == odds_trifecta_page_3.odds_id })
  end

end
