RSpec.describe "odds win page spec" do

  before do
    repo = ScoringHorseRacing::SpecUtil.build_resource_repository
    repo.remove_s3_objects
  end

  it "download" do
    # setup
    result_html = File.open("spec/data/result.20180624.hanshin.1.html").read
    result_page = ScoringHorseRacing::Rule::ResultPage.new("1809030801", result_html, @downloader, @repo)

    # execute - インスタンス化
    odds_win_page = result_page.odds_win_page

    # check
    assert_equal "1809030801", odds_win_page.odds_id
    assert_nil odds_win_page.win_results
    assert_nil odds_win_page.place_results
    assert_nil odds_win_page.bracket_quinella_results
    assert_nil odds_win_page.odds_quinella_page
    assert_nil odds_win_page.odds_quinella_place_page
    assert_nil odds_win_page.odds_exacta_page
    assert_nil odds_win_page.odds_trio_page
    assert_nil odds_win_page.odds_trifecta_page
    assert_not odds_win_page.valid?
    assert_not odds_win_page.exists?

    # execute - ダウンロード
    odds_win_page.download_from_web!

    # check
    assert_equal "1809030801", odds_win_page.odds_id
    assert_not_nil odds_win_page.win_results # FIXME
    assert_not_nil odds_win_page.place_results # FIXME
    assert_not_nil odds_win_page.bracket_quinella_results # FIXME
    assert_equal "1809030801", odds_win_page.odds_quinella_page.odds_id
    assert_equal "1809030801", odds_win_page.odds_quinella_place_page.odds_id
    assert_equal "1809030801", odds_win_page.odds_exacta_page.odds_id
    assert_equal "1809030801", odds_win_page.odds_trio_page.odds_id
    assert_equal "1809030801", odds_win_page.odds_trifecta_page.odds_id
    assert odds_win_page.valid?
    assert_not odds_win_page.exists?

    # execute - 保存
    odds_win_page.save!

    # check
    assert odds_win_page.valid?
    assert odds_win_page.exists?

    # execute - 再インスタンス化
    result_page = ScoringHorseRacing::Rule::ResultPage.new("1809030801", result_html, @downloader, @repo)
    odds_win_page_2 = result_page.odds_win_page

    # check
    assert_equal "1809030801", odds_win_page_2.odds_id
    assert_nil odds_win_page_2.win_results
    assert_nil odds_win_page_2.place_results
    assert_nil odds_win_page_2.bracket_quinella_results
    assert_nil odds_win_page_2.odds_quinella_page
    assert_nil odds_win_page_2.odds_quinella_place_page
    assert_nil odds_win_page_2.odds_exacta_page
    assert_nil odds_win_page_2.odds_trio_page
    assert_nil odds_win_page_2.odds_trifecta_page
    assert_not odds_win_page_2.valid?
    assert odds_win_page_2.exists?

    # execute - 再ダウンロード
    odds_win_page_2.download_from_s3!

    # check
    assert_equal "1809030801", odds_win_page_2.odds_id
    assert_not_nil odds_win_page_2.win_results
    assert_not_nil odds_win_page_2.place_results
    assert_not_nil odds_win_page_2.bracket_quinella_results
    assert_equal "1809030801", odds_win_page_2.odds_quinella_page.odds_id
    assert_equal "1809030801", odds_win_page_2.odds_quinella_place_page.odds_id
    assert_equal "1809030801", odds_win_page_2.odds_exacta_page.odds_id
    assert_equal "1809030801", odds_win_page_2.odds_trio_page.odds_id
    assert_equal "1809030801", odds_win_page_2.odds_trifecta_page.odds_id
    assert odds_win_page_2.valid?
    assert odds_win_page_2.exists?

    # execute - 上書き保存
    odds_win_page_2.save!
  end

  it "download: case invalid html" do
    # execute - 不正なHTMLをインスタンス化
    odds_win_page = ScoringHorseRacing::Rule::OddsWinPage.new("0000000000", "Invalid html", @downloader, @repo)

    # check
    assert_equal "0000000000", odds_win_page.odds_id
    assert_not odds_win_page.valid?
    assert_not odds_win_page.exists?

    # execute - ダウンロード -> 失敗
    odds_win_page.download_from_web!

    # check
    assert_equal "0000000000", odds_win_page.odds_id
    assert_not odds_win_page.valid?
    assert_not odds_win_page.exists?

    # execute - 保存 -> 失敗
    assert_raises "Invalid" do
      odds_win_page.save!
    end

    # check
    assert_equal "0000000000", odds_win_page.odds_id
    assert_not odds_win_page.valid?
    assert_not odds_win_page.exists?
  end

  it "parse" do
    # setup
    odds_win_page_html = File.open("spec/data/odds_win.20180624.hanshin.1.html").read

    # execute
    odds_win_page = ScoringHorseRacing::Rule::OddsWinPage.new("1809030801", odds_win_page_html, @downloader, @repo)

    # check
    assert_equal "1809030801", odds_win_page.odds_id
    assert_not_nil odds_win_page.win_results # FIXME
    assert_not_nil odds_win_page.place_results # FIXME
    assert_not_nil odds_win_page.bracket_quinella_results # FIXME
    assert_equal "1809030801", odds_win_page.odds_quinella_page.odds_id
    assert_equal "1809030801", odds_win_page.odds_quinella_place_page.odds_id
    assert_equal "1809030801", odds_win_page.odds_exacta_page.odds_id
    assert_equal "1809030801", odds_win_page.odds_trio_page.odds_id
    assert_equal "1809030801", odds_win_page.odds_trifecta_page.odds_id
    assert odds_win_page.valid?
    assert_not odds_win_page.exists?
  end

  it "parse: invalid html" do
    # execute
    odds_win_page = ScoringHorseRacing::Rule::OddsWinPage.new("0000000000", "Invalid html", @downloader, @repo)

    # check
    assert_equal "0000000000", odds_win_page.odds_id
    assert_nil odds_win_page.win_results
    assert_nil odds_win_page.place_results
    assert_nil odds_win_page.bracket_quinella_results
    assert_nil odds_win_page.odds_quinella_page
    assert_nil odds_win_page.odds_quinella_place_page
    assert_nil odds_win_page.odds_exacta_page
    assert_nil odds_win_page.odds_trio_page
    assert_nil odds_win_page.odds_trifecta_page
    assert_not odds_win_page.valid?
    assert_not odds_win_page.exists?
  end

  it "save, and overwrite" do
    # setup
    odds_win_page_html = File.open("spec/data/odds_win.20180624.hanshin.1.html").read

    # execute
    odds_win_page = ScoringHorseRacing::Rule::OddsWinPage.new("1809030801", odds_win_page_html, @downloader, @repo)

    # check
    assert_equal "1809030801", odds_win_page.odds_id
    assert_not_nil odds_win_page.win_results # FIXME
    assert_not_nil odds_win_page.place_results # FIXME
    assert_not_nil odds_win_page.bracket_quinella_results # FIXME
    assert_equal "1809030801", odds_win_page.odds_quinella_page.odds_id
    assert_equal "1809030801", odds_win_page.odds_quinella_place_page.odds_id
    assert_equal "1809030801", odds_win_page.odds_exacta_page.odds_id
    assert_equal "1809030801", odds_win_page.odds_trio_page.odds_id
    assert_equal "1809030801", odds_win_page.odds_trifecta_page.odds_id
    assert odds_win_page.valid?
    assert_not odds_win_page.exists?

    # execute - 保存
    odds_win_page.save!

    # check
    assert odds_win_page.valid?
    assert odds_win_page.exists?

    # execute - 再ダウンロード
    odds_win_page.download_from_web!

    # check
    assert odds_win_page.valid?
    assert odds_win_page.exists?

    # execute - 再保存
    odds_win_page.save!

    # check
    assert odds_win_page.valid?
    assert odds_win_page.exists?
  end

  it "save: invalid" do
    # execute - 不正なHTMLをインスタンス化
    odds_win_page = ScoringHorseRacing::Rule::OddsWinPage.new("0000000000", "Invalid html", @downloader, @repo)

    # check
    assert_not odds_win_page.valid?
    assert_not odds_win_page.exists?

    # execute - 保存しようとして例外がスローされる
    assert_raises "Invalid" do
      odds_win_page.save!
    end

    # check
    assert_not odds_win_page.valid?
    assert_not odds_win_page.exists?
  end

end
