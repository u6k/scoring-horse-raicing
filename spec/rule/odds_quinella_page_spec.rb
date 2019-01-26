RSpec.describe "odds quinella page spec" do

  before do
    @downloader = ScoringHorseRacing::SpecUtil.build_downloader

    @repo = ScoringHorseRacing::SpecUtil.build_resource_repository
    @repo.remove_s3_objects
  end

  it "download" do
    # setup
    odds_win_page_html = File.open("spec/data/odds_win.20180624.hanshin.1.html").read
    odds_win_page = ScoringHorseRacing::Rule::OddsWinPage.new("1809030801", odds_win_page_html, @downloader, @repo)

    # execute - new
    odds_quinella_page = odds_win_page.odds_quinella_page

    # check
    expect(odds_quinella_page.odds_id).to eq "1809030801"
    expect(odds_quinella_page.quinella_results).to be nil
    expect(odds_quinella_page.valid?).to be_falsey
    expect(odds_quinella_page.exists?).to be_falsey

    # execute - download
    odds_quinella_page.download_from_web!

    # check
    expect(odds_quinella_page.odds_id).to eq "1809030801"
    expect(odds_quinella_page.quinella_results).not_to be nil
    expect(odds_quinella_page.valid?).to be_truthy
    expect(odds_quinella_page.exists?).to be_falsey

    # execute - save
    odds_quinella_page.save!

    # check
    expect(odds_quinella_page.valid?).to be_truthy
    expect(odds_quinella_page.exists?).to be_truthy

    # execute - re-new
    odds_win_page = ScoringHorseRacing::Rule::OddsWinPage.new("1809030801", odds_win_page_html, @downloader, @repo)
    odds_quinella_page_2 = odds_win_page.odds_quinella_page

    # check
    expect(odds_quinella_page_2.odds_id).to eq "1809030801"
    expect(odds_quinella_page_2.quinella_results).to be nil
    expect(odds_quinella_page_2.valid?).to be_falsey
    expect(odds_quinella_page_2.exists?).to be_truthy

    # execute - download
    odds_quinella_page_2.download_from_s3!

    # check
    expect(odds_quinella_page_2.valid?).to be_truthy
    expect(odds_quinella_page_2.exists?).to be_truthy

    # execute - overwrite
    odds_quinella_page_2.save!
  end

  it "download: invalid html" do
    # execute - new from invalid html
    odds_quinella_page = ScoringHorseRacing::Rule::OddsQuinellaPage.new("0000000000", "Invalid html", @downloader, @repo)

    # check
    expect(odds_quinella_page.odds_id).to eq "0000000000"
    expect(odds_quinella_page.valid?).to be_falsey
    expect(odds_quinella_page.exists?).to be_falsey

    # execute - download -> fail
    odds_quinella_page.download_from_web!

    # check
    expect(odds_quinella_page.valid?).to be_falsey
    expect(odds_quinella_page.exists?).to be_falsey

    # execute - save -> fail
    expect(odds_quinella_page.save!).to raise_error "Invalid"

    # check
    expect(odds_quinella_page.valid?).to be_falsey
    expect(odds_quinella_page.exists?).to be_falsey
  end

  it "parse" do
    # setup
    odds_quinella_page_html = File.open("spec/data/odds_quinella.20180624.hanshin.1.html").read

    # execute
    odds_quinella_page = ScoringHorseRacing::Rule::OddsQuinellaPage.new("1809030801", odds_quinella_page_html, @downloader, @repo)

    # check
    expect(odds_quinella_page.odds_id).to eq "1809030801"
    expect(odds_quinella_page.quinella_results).not_to be nil
    expect(odds_quinella_page.valid?).to be_truthy
    expect(odds_quinella_page.exists?).to be_falsey
  end

  it "parse: invalid html" do
    # execute
    odds_quinella_page = ScoringHorseRacing::Rule::OddsQuinellaPage.new("0000000000", "Invalid html", @downloader, @repo)

    # check
    expect(odds_quinella_page.odds_id).to eq "0000000000"
    expect(odds_quinella_page.quinella_results).to be nil
    expect(odds_quinella_page.valid?).to be_falsey
    expect(odds_quinella_page.exists?).to be_falsey
  end

  it "save, and overwrite" do
    # setup
    odds_quinella_page_html = File.open("spec/data/odds_quinella.20180624.hanshin.1.html").read

    # execute
    odds_quinella_page = ScoringHorseRacing::Rule::OddsQuinellaPage.new("1809030801", odds_quinella_page_html, @downloader, @repo)

    # check
    expect(odds_quinella_page.odds_id).to eq "1809030801"
    expect(odds_quinella_page.quinella_results).not_to be nil
    expect(odds_quinella_page.valid?).to be_truthy
    expect(odds_quinella_page.exists?).to be_falsey

    # execute - save
    odds_quinella_page.save!

    # check
    expect(odds_quinella_page.valid?).to be_truthy
    expect(odds_quinella_page.exists?).to be_truthy

    # execute - re-download
    odds_quinella_page.download_from_web!

    # check
    expect(odds_quinella_page.valid?).to be_truthy
    expect(odds_quinella_page.exists?).to be_truthy

    # execute - re-save
    odds_quinella_page.save!

    # check
    expect(odds_quinella_page.valid?).to be_truthy
    expect(odds_quinella_page.exists?).to be_truthy
  end

  it "save: invalid" do
    # execute - new invalid html
    odds_quinella_page = ScoringHorseRacing::Rule::OddsQuinellaPage.new("0000000000", "Invalid html", @downloader, @repo)

    # check
    expect(odds_quinella_page.valid?).to be_falsey
    expect(odds_quinella_page.exists?).to be_falsey

    # execute - raised exception when save
    expect(odds_quinella_page.save!).to raise_error "Invalid"

    # check
    expect(odds_quinella_page.valid?).to be_falsey
    expect(odds_quinella_page.exists?).to be_falsey
  end

end

