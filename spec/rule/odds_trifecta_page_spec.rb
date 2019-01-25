RSpec.describe "odds trifecta page spec" do

  before do
    repo = ScoringHorseRacing::SpecUtil.build_resource_repository
    repo.remove_s3_objects
  end

  it "download" do
    # setup
    odds_win_page_html = File.open("spec/data/odds_win.20180624.hanshin.1.html").read
    odds_win_page = ScoringHorseRacing::Rule::OddsWinPage.new("1809030801", odds_win_page_html, @downloader, @repo)

    # execute - new
    odds_trifecta_page = odds_win_page.odds_trifecta_page

    # check
    assert_equal "1809030801", odds_trifecta_page.odds_id
    assert_equal 1, odds_trifecta_page.horse_number
    assert_nil odds_trifecta_page.trifecta_results
    assert_nil odds_trifecta_page.odds_trifecta_pages
    assert_not odds_trifecta_page.valid?
    assert_not odds_trifecta_page.exists?

    # execute - download
    odds_trifecta_page.download_from_web!

    # check
    assert_equal "1809030801", odds_trifecta_page.odds_id
    assert_equal 1, odds_trifecta_page.horse_number
    assert_not_nil odds_trifecta_page.trifecta_results # FIXME
    assert_equal 16, odds_trifecta_page.odds_trifecta_pages.length
    assert odds_trifecta_page.valid?
    assert_not odds_trifecta_page.exists?

    # execute - save
    odds_trifecta_page.save!

    # check
    assert odds_trifecta_page.valid?
    assert odds_trifecta_page.exists?

    # execute - re-new
    odds_win_page = ScoringHorseRacing::Rule::OddsWinPage.new("1809030801", odds_win_page_html, @downloader, @repo)
    odds_trifecta_page_2 = odds_win_page.odds_trifecta_page

    # check
    assert_equal "1809030801", odds_trifecta_page_2.odds_id
    assert_equal 1, odds_trifecta_page_2.horse_number
    assert_nil odds_trifecta_page_2.trifecta_results
    assert_nil odds_trifecta_page_2.odds_trifecta_pages
    assert_not odds_trifecta_page_2.valid?
    assert odds_trifecta_page_2.exists?

    # execute - download
    odds_trifecta_page_2.download_from_s3!

    # check
    assert_equal "1809030801", odds_trifecta_page_2.odds_id
    assert_equal 1, odds_trifecta_page_2.horse_number
    assert_not_nil odds_trifecta_page_2.trifecta_results
    assert_equal 16, odds_trifecta_page_2.odds_trifecta_pages.length
    assert odds_trifecta_page_2.valid?
    assert odds_trifecta_page_2.exists?

    # execute - overwrite
    odds_trifecta_page_2.save!
  end

  it "download: invalid html" do
    # execute - new from invalid html
    odds_trifecta_page = ScoringHorseRacing::Rule::OddsTrifectaPage.new("0000000000", nil, "Invalid html", @downloader, @repo)

    # check
    assert_equal "0000000000", odds_trifecta_page.odds_id
    assert_equal 1, odds_trifecta_page.horse_number
    assert_not odds_trifecta_page.valid?
    assert_not odds_trifecta_page.exists?

    # execute - download -> fail
    odds_trifecta_page.download_from_web!

    # check
    assert_not odds_trifecta_page.valid?
    assert_not odds_trifecta_page.exists?

    # execute - save -> fail
    assert_raises "Invalid" do
      odds_trifecta_page.save!
    end

    # check
    assert_not odds_trifecta_page.valid?
    assert_not odds_trifecta_page.exists?
  end

  it "parse" do
    # setup
    odds_trifecta_page_html = File.open("spec/data/odds_trifecta.20180624.hanshin.1.1.html").read

    # execute
    odds_trifecta_page = ScoringHorseRacing::Rule::OddsTrifectaPage.new("1809030801", nil, odds_trifecta_page_html, @downloader, @repo)

    # check
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

  it "parse: invalid html" do
    # execute
    odds_trifecta_page = ScoringHorseRacing::Rule::OddsTrifectaPage.new("0000000000", nil, "Invalid html", @downloader, @repo)

    # check
    assert_equal "0000000000", odds_trifecta_page.odds_id
    assert_equal 1, odds_trifecta_page.horse_number
    assert_nil odds_trifecta_page.trifecta_results
    assert_nil odds_trifecta_page.odds_trifecta_pages
    assert_not odds_trifecta_page.valid?
    assert_not odds_trifecta_page.exists?
  end

  it "save, and overwrite" do
    # setup
    odds_trifecta_page_html = File.open("spec/data/odds_trifecta.20180624.hanshin.1.1.html").read

    # execute
    odds_trifecta_page = ScoringHorseRacing::Rule::OddsTrifectaPage.new("1809030801", nil, odds_trifecta_page_html, @downloader, @repo)

    # check
    assert_equal "1809030801", odds_trifecta_page.odds_id
    assert_equal 1, odds_trifecta_page.horse_number
    assert_not_nil odds_trifecta_page.trifecta_results # FIXME
    assert_equal 16, odds_trifecta_page.odds_trifecta_pages.length
    assert odds_trifecta_page.valid?
    assert_not odds_trifecta_page.exists?

    # execute - save
    odds_trifecta_page.save!

    # check
    assert odds_trifecta_page.valid?
    assert odds_trifecta_page.exists?

    # execute - re-download
    odds_trifecta_page.download_from_web!

    # check
    assert odds_trifecta_page.valid?
    assert odds_trifecta_page.exists?

    # execute - re-save
    odds_trifecta_page.save!

    # check
    assert odds_trifecta_page.valid?
    assert odds_trifecta_page.exists?
  end

  it "save: invalid" do
    # execute - new invalid html
    odds_trifecta_page = ScoringHorseRacing::Rule::OddsTrifectaPage.new("0000000000", "Invalid html", @downloader, @repo)

    # check
    assert_not odds_trifecta_page.valid?
    assert_not odds_trifecta_page.exists?

    # execute - raised exception when save
    assert_raises "Invalid" do
      odds_trifecta_page.save!
    end

    # check
    assert_not odds_trifecta_page.valid?
    assert_not odds_trifecta_page.exists?
  end

end

