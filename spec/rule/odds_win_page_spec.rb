# RSpec.describe "odds win page spec" do

#   before do
#     @downloader = ScoringHorseRacing::SpecUtil.build_downloader

#     @repo = ScoringHorseRacing::SpecUtil.build_resource_repository
#     @repo.remove_s3_objects
#   end

#   it "download" do
#     # setup
#     result_html = File.open("spec/data/result.20180624.hanshin.1.html").read
#     result_page = ScoringHorseRacing::Rule::ResultPage.new("1809030801", result_html, @downloader, @repo)

#     # execute - インスタンス化
#     odds_win_page = result_page.odds_win_page

#     # check
#     expect(odds_win_page.odds_id).to eq "1809030801"
#     expect(odds_win_page.win_results).to be nil
#     expect(odds_win_page.place_results).to be nil
#     expect(odds_win_page.bracket_quinella_results).to be nil
#     expect(odds_win_page.odds_quinella_page).to be nil
#     expect(odds_win_page.odds_quinella_place_page).to be nil
#     expect(odds_win_page.odds_exacta_page).to be nil
#     expect(odds_win_page.odds_trio_page).to be nil
#     expect(odds_win_page.odds_trifecta_page).to be nil
#     expect(odds_win_page.valid?).to be_falsey
#     expect(odds_win_page.exists?).to be_falsey

#     # execute - ダウンロード
#     odds_win_page.download_from_web!

#     # check
#     expect(odds_win_page.odds_id).to eq "1809030801"
#     expect(odds_win_page.win_results).not_to be nil
#     expect(odds_win_page.place_results).not_to be nil
#     expect(odds_win_page.bracket_quinella_results).not_to be nil
#     expect(odds_win_page.odds_quinella_page.odds_id).to eq "1809030801"
#     expect(odds_win_page.odds_quinella_place_page.odds_id).to eq "1809030801"
#     expect(odds_win_page.odds_exacta_page.odds_id).to eq "1809030801"
#     expect(odds_win_page.odds_trio_page.odds_id).to eq "1809030801"
#     expect(odds_win_page.odds_trifecta_page.odds_id).to eq "1809030801"
#     expect(odds_win_page.valid?).to be_truthy
#     expect(odds_win_page.exists?).to be_falsey

#     # execute - 保存
#     odds_win_page.save!

#     # check
#     expect(odds_win_page.valid?).to be_truthy
#     expect(odds_win_page.exists?).to be_truthy

#     # execute - 再インスタンス化
#     result_page = ScoringHorseRacing::Rule::ResultPage.new("1809030801", result_html, @downloader, @repo)
#     odds_win_page_2 = result_page.odds_win_page

#     # check
#     expect(odds_win_page_2.odds_id).to eq "1809030801"
#     expect(odds_win_page_2.win_results).to be nil
#     expect(odds_win_page_2.place_results).to be nil
#     expect(odds_win_page_2.bracket_quinella_results).to be nil
#     expect(odds_win_page_2.odds_quinella_page).to be nil
#     expect(odds_win_page_2.odds_quinella_place_page).to be nil
#     expect(odds_win_page_2.odds_exacta_page).to be nil
#     expect(odds_win_page_2.odds_trio_page).to be nil
#     expect(odds_win_page_2.odds_trifecta_page).to be nil
#     expect(odds_win_page_2.valid?).to be_falsey
#     expect(odds_win_page_2.exists?).to be_truthy

#     # execute - 再ダウンロード
#     odds_win_page_2.download_from_s3!

#     # check
#     expect(odds_win_page_2.odds_id).to eq "1809030801"
#     expect(odds_win_page_2.win_results).not_to be nil
#     expect(odds_win_page_2.place_results).not_to be nil
#     expect(odds_win_page_2.bracket_quinella_results).not_to be nil
#     expect(odds_win_page_2.odds_quinella_page.odds_id).to eq "1809030801"
#     expect(odds_win_page_2.odds_quinella_place_page.odds_id).to eq "1809030801"
#     expect(odds_win_page_2.odds_exacta_page.odds_id).to eq "1809030801"
#     expect(odds_win_page_2.odds_trio_page.odds_id).to eq "1809030801"
#     expect(odds_win_page_2.odds_trifecta_page.odds_id).to eq "1809030801"
#     expect(odds_win_page_2.valid?).to be_truthy
#     expect(odds_win_page_2.exists?).to be_truthy

#     # execute - 上書き保存
#     odds_win_page_2.save!
#   end

#   it "download: case invalid html" do
#     # execute - 不正なHTMLをインスタンス化
#     odds_win_page = ScoringHorseRacing::Rule::OddsWinPage.new("0000000000", "Invalid html", @downloader, @repo)

#     # check
#     expect(odds_win_page.odds_id).to eq "0000000000"
#     expect(odds_win_page.valid?).to be_falsey
#     expect(odds_win_page.exists?).to be_falsey

#     # execute - ダウンロード -> 失敗
#     odds_win_page.download_from_web!

#     # check
#     expect(odds_win_page.odds_id).to eq "0000000000"
#     expect(odds_win_page.valid?).to be_falsey
#     expect(odds_win_page.exists?).to be_falsey

#     # execute - 保存 -> 失敗
#     expect { odds_win_page.save! }.to raise_error "Invalid"

#     # check
#     expect(odds_win_page.odds_id).to eq "0000000000"
#     expect(odds_win_page.valid?).to be_falsey
#     expect(odds_win_page.exists?).to be_falsey
#   end

#   it "parse" do
#     # setup
#     odds_win_page_html = File.open("spec/data/odds_win.20180624.hanshin.1.html").read

#     # execute
#     odds_win_page = ScoringHorseRacing::Rule::OddsWinPage.new("1809030801", odds_win_page_html, @downloader, @repo)

#     # check
#     expect(odds_win_page.odds_id).to eq "1809030801"
#     expect(odds_win_page.win_results).not_to be nil
#     expect(odds_win_page.place_results).not_to be nil
#     expect(odds_win_page.bracket_quinella_results).not_to be nil
#     expect(odds_win_page.odds_quinella_page.odds_id).to eq "1809030801"
#     expect(odds_win_page.odds_quinella_place_page.odds_id).to eq "1809030801"
#     expect(odds_win_page.odds_exacta_page.odds_id).to eq "1809030801"
#     expect(odds_win_page.odds_trio_page.odds_id).to eq "1809030801"
#     expect(odds_win_page.odds_trifecta_page.odds_id).to eq "1809030801"
#     expect(odds_win_page.valid?).to be_truthy
#     expect(odds_win_page.exists?).to be_falsey
#   end

#   it "parse: invalid html" do
#     # execute
#     odds_win_page = ScoringHorseRacing::Rule::OddsWinPage.new("0000000000", "Invalid html", @downloader, @repo)

#     # check
#     expect(odds_win_page.odds_id).to eq "0000000000"
#     expect(odds_win_page.win_results).to be nil
#     expect(odds_win_page.place_results).to be nil
#     expect(odds_win_page.bracket_quinella_results).to be nil
#     expect(odds_win_page.odds_quinella_page).to be nil
#     expect(odds_win_page.odds_quinella_place_page).to be nil
#     expect(odds_win_page.odds_exacta_page).to be nil
#     expect(odds_win_page.odds_trio_page).to be nil
#     expect(odds_win_page.odds_trifecta_page).to be nil
#     expect(odds_win_page.valid?).to be_falsey
#     expect(odds_win_page.exists?).to be_falsey
#   end

#   it "save, and overwrite" do
#     # setup
#     odds_win_page_html = File.open("spec/data/odds_win.20180624.hanshin.1.html").read

#     # execute
#     odds_win_page = ScoringHorseRacing::Rule::OddsWinPage.new("1809030801", odds_win_page_html, @downloader, @repo)

#     # check
#     expect(odds_win_page.odds_id).to eq "1809030801"
#     expect(odds_win_page.win_results).not_to be nil
#     expect(odds_win_page.place_results).not_to be nil
#     expect(odds_win_page.bracket_quinella_results).not_to be nil
#     expect(odds_win_page.odds_quinella_page.odds_id).to eq "1809030801"
#     expect(odds_win_page.odds_quinella_place_page.odds_id).to eq "1809030801"
#     expect(odds_win_page.odds_exacta_page.odds_id).to eq "1809030801"
#     expect(odds_win_page.odds_trio_page.odds_id).to eq "1809030801"
#     expect(odds_win_page.odds_trifecta_page.odds_id).to eq "1809030801"
#     expect(odds_win_page.valid?).to be_truthy
#     expect(odds_win_page.exists?).to be_falsey

#     # execute - 保存
#     odds_win_page.save!

#     # check
#     expect(odds_win_page.valid?).to be_truthy
#     expect(odds_win_page.exists?).to be_truthy

#     # execute - 再ダウンロード
#     odds_win_page.download_from_web!

#     # check
#     expect(odds_win_page.valid?).to be_truthy
#     expect(odds_win_page.exists?).to be_truthy

#     # execute - 再保存
#     odds_win_page.save!

#     # check
#     expect(odds_win_page.valid?).to be_truthy
#     expect(odds_win_page.exists?).to be_truthy
#   end

#   it "save: invalid" do
#     # execute - 不正なHTMLをインスタンス化
#     odds_win_page = ScoringHorseRacing::Rule::OddsWinPage.new("0000000000", "Invalid html", @downloader, @repo)

#     # check
#     expect(odds_win_page.valid?).to be_falsey
#     expect(odds_win_page.exists?).to be_falsey

#     # execute - 保存しようとして例外がスローされる
#     expect { odds_win_page.save! }.to raise_error "Invalid"

#     # check
#     expect(odds_win_page.valid?).to be_falsey
#     expect(odds_win_page.exists?).to be_falsey
#   end

# end
