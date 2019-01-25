RSpec.describe "odds quinella place page spec" do

  before do
    repo = build_resource_repository
    repo.remove_s3_objects
  end

  it "download" do
    # setup
    odds_win_page_html = File.open("test/fixtures/files/odds_win.20180624.hanshin.1.html").read
    odds_win_page = OddsWinPage.new("1809030801", odds_win_page_html)

    # execute - new
    odds_quinella_place_page = odds_win_page.odds_quinella_place_page

    # check
    assert_equal "1809030801", odds_quinella_place_page.odds_id
    assert_nil odds_quinella_place_page.quinella_place_results
    assert_not odds_quinella_place_page.valid?
    assert_not odds_quinella_place_page.exists?

    # execute - download
    odds_quinella_place_page.download_from_web!

    # check
    assert_equal "1809030801", odds_quinella_place_page.odds_id
    assert_not_nil odds_quinella_place_page.quinella_place_results # FIXME
    assert odds_quinella_place_page.valid?
    assert_not odds_quinella_place_page.exists?

    # execute - save
    odds_quinella_place_page.save!

    # check
    assert odds_quinella_place_page.valid?
    assert odds_quinella_place_page.exists?

    # execute - re-new
    odds_win_page = OddsWinPage.new("1809030801", odds_win_page_html)
    odds_quinella_place_page_2 = odds_win_page.odds_quinella_place_page

    # check
    assert_equal "1809030801", odds_quinella_place_page_2.odds_id
    assert_nil odds_quinella_place_page_2.quinella_place_results
    assert_not odds_quinella_place_page_2.valid?
    assert odds_quinella_place_page_2.exists?

    # execute - download
    odds_quinella_place_page_2.download_from_s3!

    # check
    assert odds_quinella_place_page_2.valid?
    assert odds_quinella_place_page_2.exists?

    # execute - overwrite
    odds_quinella_place_page_2.save!
  end

  it "download: invalid html" do
    # execute - new from invalid html
    odds_quinella_place_page = OddsQuinellaPlacePage.new("0000000000", "Invalid html")

    # check
    assert_equal "0000000000", odds_quinella_place_page.odds_id
    assert_not odds_quinella_place_page.valid?
    assert_not odds_quinella_place_page.exists?

    # execute - download -> fail
    odds_quinella_place_page.download_from_web!

    # check
    assert_not odds_quinella_place_page.valid?
    assert_not odds_quinella_place_page.exists?

    # execute - save -> fail
    assert_raises "Invalid" do
      odds_quinella_place_page.save!
    end

    # check
    assert_not odds_quinella_place_page.valid?
    assert_not odds_quinella_place_page.exists?
  end

  it "parse" do
    # setup
    odds_quinella_place_page_html = File.open("test/fixtures/files/odds_quinella_place.20180624.hanshin.1.html").read

    # execute
    odds_quinella_place_page = OddsQuinellaPlacePage.new("1809030801", odds_quinella_place_page_html)

    # check
    assert_equal "1809030801", odds_quinella_place_page.odds_id
    assert_not_nil odds_quinella_place_page.quinella_place_results # FIXME
    assert odds_quinella_place_page.valid?
    assert_not odds_quinella_place_page.exists?
  end

  it "parse: invalid html" do
    # execute
    odds_quinella_place_page = OddsQuinellaPlacePage.new("0000000000", "Invalid html")

    # check
    assert_equal "0000000000", odds_quinella_place_page.odds_id
    assert_nil odds_quinella_place_page.quinella_place_results
    assert_not odds_quinella_place_page.valid?
    assert_not odds_quinella_place_page.exists?
  end

  it "save, and overwrite" do
    # setup
    odds_quinella_place_page_html = File.open("test/fixtures/files/odds_quinella_place.20180624.hanshin.1.html").read

    # execute
    odds_quinella_place_page = OddsQuinellaPlacePage.new("1809030801", odds_quinella_place_page_html)

    # check
    assert_equal "1809030801", odds_quinella_place_page.odds_id
    assert_not_nil odds_quinella_place_page.quinella_place_results # FIXME
    assert odds_quinella_place_page.valid?
    assert_not odds_quinella_place_page.exists?

    # execute - save
    odds_quinella_place_page.save!

    # check
    assert odds_quinella_place_page.valid?
    assert odds_quinella_place_page.exists?

    # execute - re-download
    odds_quinella_place_page.download_from_web!

    # check
    assert odds_quinella_place_page.valid?
    assert odds_quinella_place_page.exists?

    # execute - re-save
    odds_quinella_place_page.save!

    # check
    assert odds_quinella_place_page.valid?
    assert odds_quinella_place_page.exists?
  end

  it "save: invalid" do
    # execute - new invalid html
    odds_quinella_place_page = OddsQuinellaPlacePage.new("0000000000", "Invalid html")

    # check
    assert_not odds_quinella_place_page.valid?
    assert_not odds_quinella_place_page.exists?

    # execute - raised exception when save
    assert_raises "Invalid" do
      odds_quinella_place_page.save!
    end

    # check
    assert_not odds_quinella_place_page.valid?
    assert_not odds_quinella_place_page.exists?
  end

end

