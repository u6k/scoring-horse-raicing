RSpec.describe "odds exacta page spec" do

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
    odds_exacta_page = odds_win_page.odds_exacta_page

    # check
    expect(odds_exacta_page.odds_id).to eq "1809030801"
    expect(odds_exacta_page.exacta_results).to be nil
    expect(odds_exacta_page.valid?).to be_falsey
    expect(odds_exacta_page.exists?).to be_falsey

    # execute - download
    odds_exacta_page.download_from_web!

    # check
    expect(odds_exacta_page.odds_id).to eq "1809030801"
    expect(odds_exacta_page.exacta_results).not_to be nil
    expect(odds_exacta_page.valid?).to be_truthy
    expect(odds_exacta_page.exists?).to be_falsey

    # execute - save
    odds_exacta_page.save!

    # check
    expect(odds_exacta_page.valid?).to be_truthy
    expect(odds_exacta_page.exists?).to be_truthy

    # execute - re-new
    odds_win_page = ScoringHorseRacing::Rule::OddsWinPage.new("1809030801", odds_win_page_html, @downloader, @repo)
    odds_exacta_page_2 = odds_win_page.odds_exacta_page

    # check
    expect(odds_exacta_page_2.odds_id).to eq "1809030801"
    expect(odds_exacta_page_2.exacta_results).to be nil
    expect(odds_exacta_page_2.valid?).to be_falsey
    expect(odds_exacta_page_2.exists?).to be_truthy

    # execute - download
    odds_exacta_page_2.download_from_s3!

    # check
    expect(odds_exacta_page_2.valid?).to be_truthy
    expect(odds_exacta_page_2.exists?).to be_truthy

    # execute - overwrite
    odds_exacta_page_2.save!
  end

  it "download: invalid html" do
    # execute - new from invalid html
    odds_exacta_page = ScoringHorseRacing::Rule::OddsExactaPage.new("0000000000", "Invalid html", @downloader, @repo)

    # check
    expect(odds_exacta_page.odds_id).to eq "0000000000"
    expect(odds_exacta_page.valid?).to be_falsey
    expect(odds_exacta_page.exists?).to be_falsey

    # execute - download -> fail
    odds_exacta_page.download_from_web!

    # check
    expect(odds_exacta_page.valid?).to be_falsey
    expect(odds_exacta_page.exists?).to be_falsey

    # execute - save -> fail
    expect { odds_exacta_page.save! }.to raise_error "Invalid"

    # check
    expect(odds_exacta_page.valid?).to be_falsey
    expect(odds_exacta_page.exists?).to be_falsey
  end

  it "parse" do
    # setup
    odds_exacta_page_html = File.open("spec/data/odds_exacta.20180624.hanshin.1.html").read

    # execute
    odds_exacta_page = ScoringHorseRacing::Rule::OddsExactaPage.new("1809030801", odds_exacta_page_html, @downloader, @repo)

    # check
    expect(odds_exacta_page.odds_id).to eq "1809030801"
    expect(odds_exacta_page.exacta_results).not_to be nil
    expect(odds_exacta_page.valid?).to be_truthy
    expect(odds_exacta_page.exists?).to be_falsey
  end

  it "parse: invalid html" do
    # execute
    odds_exacta_page = ScoringHorseRacing::Rule::OddsExactaPage.new("0000000000", "Invalid html", @downloader, @repo)

    # check
    expect(odds_exacta_page.odds_id).to eq "0000000000"
    expect(odds_exacta_page.exacta_results).to be nil
    expect(odds_exacta_page.valid?).to be_falsey
    expect(odds_exacta_page.exists?).to be_falsey
  end

  it "save, and overwrite" do
    # setup
    odds_exacta_page_html = File.open("spec/data//odds_exacta.20180624.hanshin.1.html").read

    # execute
    odds_exacta_page = ScoringHorseRacing::Rule::OddsExactaPage.new("1809030801", odds_exacta_page_html, @downloader, @repo)

    # check
    expect(odds_exacta_page.odds_id).to eq "1809030801"
    expect(odds_exacta_page.exacta_results).not_to be nil
    expect(odds_exacta_page.valid?).to be_truthy
    expect(odds_exacta_page.exists?).to be_falsey

    # execute - save
    odds_exacta_page.save!

    # check
    expect(odds_exacta_page.valid?).to be_truthy
    expect(odds_exacta_page.exists?).to be_truthy

    # execute - re-download
    odds_exacta_page.download_from_web!

    # check
    expect(odds_exacta_page.valid?).to be_truthy
    expect(odds_exacta_page.exists?).to be_truthy

    # execute - re-save
    odds_exacta_page.save!

    # check
    expect(odds_exacta_page.valid?).to be_truthy
    expect(odds_exacta_page.exists?).to be_truthy
  end

  it "save: invalid" do
    # execute - new invalid html
    odds_exacta_page = ScoringHorseRacing::Rule::OddsExactaPage.new("0000000000", "Invalid html", @downloader, @repo)

    # check
    expect(odds_exacta_page.valid?).to be_falsey
    expect(odds_exacta_page.exists?).to be_falsey

    # execute - raised exception when save
    expect { odds_exacta_page.save! }.to raise_error "Invalid"

    # check
    expect(odds_exacta_page.valid?).to be_falsey
    expect(odds_exacta_page.exists?).to be_falsey
  end

end

