# RSpec.describe "odds trifecta page spec" do

#   before do
#     @downloader = ScoringHorseRacing::SpecUtil.build_downloader

#     @repo = ScoringHorseRacing::SpecUtil.build_resource_repository
#     @repo.remove_s3_objects
#   end

#   it "download" do
#     # setup
#     odds_win_page_html = File.open("spec/data/odds_win.20180624.hanshin.1.html").read
#     odds_win_page = ScoringHorseRacing::Rule::OddsWinPage.new("1809030801", odds_win_page_html, @downloader, @repo)

#     # execute - new
#     odds_trifecta_page = odds_win_page.odds_trifecta_page

#     # check
#     expect(odds_trifecta_page.odds_id).to eq "1809030801"
#     expect(odds_trifecta_page.horse_number).to eq 1
#     expect(odds_trifecta_page.trifecta_results).to be nil
#     expect(odds_trifecta_page.odds_trifecta_pages).to be nil
#     expect(odds_trifecta_page.valid?).to be_falsey
#     expect(odds_trifecta_page.exists?).to be_falsey

#     # execute - download
#     odds_trifecta_page.download_from_web!

#     # check
#     expect(odds_trifecta_page.odds_id).to eq "1809030801"
#     expect(odds_trifecta_page.horse_number).to eq 1
#     expect(odds_trifecta_page.trifecta_results).not_to be nil
#     expect(odds_trifecta_page.odds_trifecta_pages.length).to eq 16
#     expect(odds_trifecta_page.valid?).to be_truthy
#     expect(odds_trifecta_page.exists?).to be_falsey

#     # execute - save
#     odds_trifecta_page.save!

#     # check
#     expect(odds_trifecta_page.valid?).to be_truthy
#     expect(odds_trifecta_page.exists?).to be_truthy

#     # execute - re-new
#     odds_win_page = ScoringHorseRacing::Rule::OddsWinPage.new("1809030801", odds_win_page_html, @downloader, @repo)
#     odds_trifecta_page_2 = odds_win_page.odds_trifecta_page

#     # check
#     expect(odds_trifecta_page_2.odds_id).to eq "1809030801"
#     expect(odds_trifecta_page_2.horse_number).to eq 1
#     expect(odds_trifecta_page_2.trifecta_results).to be nil
#     expect(odds_trifecta_page_2.odds_trifecta_pages).to be nil
#     expect(odds_trifecta_page_2.valid?).to be_falsey
#     expect(odds_trifecta_page_2.exists?).to be_truthy

#     # execute - download
#     odds_trifecta_page_2.download_from_s3!

#     # check
#     expect(odds_trifecta_page_2.odds_id).to eq "1809030801"
#     expect(odds_trifecta_page_2.horse_number).to eq 1
#     expect(odds_trifecta_page_2.trifecta_results).not_to be nil
#     expect(odds_trifecta_page_2.odds_trifecta_pages.length).to eq 16
#     expect(odds_trifecta_page_2.valid?).to be_truthy
#     expect(odds_trifecta_page_2.exists?).to be_truthy

#     # execute - overwrite
#     odds_trifecta_page_2.save!
#   end

#   it "download: invalid html" do
#     # execute - new from invalid html
#     odds_trifecta_page = ScoringHorseRacing::Rule::OddsTrifectaPage.new("0000000000", nil, "Invalid html", @downloader, @repo)

#     # check
#     expect(odds_trifecta_page.odds_id).to eq "0000000000"
#     expect(odds_trifecta_page.horse_number).to eq 1
#     expect(odds_trifecta_page.valid?).to be_falsey
#     expect(odds_trifecta_page.exists?).to be_falsey

#     # execute - download -> fail
#     odds_trifecta_page.download_from_web!

#     # check
#     expect(odds_trifecta_page.valid?).to be_falsey
#     expect(odds_trifecta_page.exists?).to be_falsey

#     # execute - save -> fail
#     expect { odds_trifecta_page.save! }.to raise_error "Invalid"

#     # check
#     expect(odds_trifecta_page.valid?).to be_falsey
#     expect(odds_trifecta_page.exists?).to be_falsey
#   end

#   it "parse" do
#     # setup
#     odds_trifecta_page_html = File.open("spec/data/odds_trifecta.20180624.hanshin.1.1.html").read

#     # execute
#     odds_trifecta_page = ScoringHorseRacing::Rule::OddsTrifectaPage.new("1809030801", nil, odds_trifecta_page_html, @downloader, @repo)

#     # check
#     expect(odds_trifecta_page.odds_id).to eq "1809030801"
#     expect(odds_trifecta_page.horse_number).to eq 1
#     expect(odds_trifecta_page.trifecta_results).not_to be nil
#     expect(odds_trifecta_page.valid?).to be_truthy
#     expect(odds_trifecta_page.exists?).to be_falsey

#     expect(odds_trifecta_page.odds_trifecta_pages.length).to eq 16

#     (1..16).each do |horse_number|
#       odds_trifecta_sub_page = odds_trifecta_page.odds_trifecta_pages[horse_number]

#       expect(odds_trifecta_sub_page.odds_id).to eq "1809030801"
#       expect(odds_trifecta_sub_page.horse_number).to eq horse_number
#       expect(odds_trifecta_sub_page.trifecta_results).to be nil
#       expect(odds_trifecta_sub_page.odds_trifecta_pages).to be nil
#       expect(odds_trifecta_sub_page.valid?).to be_falsey
#       expect(odds_trifecta_sub_page.exists?).to be_falsey
#     end
#   end

#   it "parse: invalid html" do
#     # execute
#     odds_trifecta_page = ScoringHorseRacing::Rule::OddsTrifectaPage.new("0000000000", nil, "Invalid html", @downloader, @repo)

#     # check
#     expect(odds_trifecta_page.odds_id).to eq "0000000000"
#     expect(odds_trifecta_page.horse_number).to eq 1
#     expect(odds_trifecta_page.trifecta_results).to be nil
#     expect(odds_trifecta_page.odds_trifecta_pages).to be nil
#     expect(odds_trifecta_page.valid?).to be_falsey
#     expect(odds_trifecta_page.exists?).to be_falsey
#   end

#   it "save, and overwrite" do
#     # setup
#     odds_trifecta_page_html = File.open("spec/data/odds_trifecta.20180624.hanshin.1.1.html").read

#     # execute
#     odds_trifecta_page = ScoringHorseRacing::Rule::OddsTrifectaPage.new("1809030801", nil, odds_trifecta_page_html, @downloader, @repo)

#     # check
#     expect(odds_trifecta_page.odds_id).to eq "1809030801"
#     expect(odds_trifecta_page.horse_number).to eq 1
#     expect(odds_trifecta_page.trifecta_results).not_to be nil
#     expect(odds_trifecta_page.odds_trifecta_pages.length).to eq 16
#     expect(odds_trifecta_page.valid?).to be_truthy
#     expect(odds_trifecta_page.exists?).to be_falsey

#     # execute - save
#     odds_trifecta_page.save!

#     # check
#     expect(odds_trifecta_page.valid?).to be_truthy
#     expect(odds_trifecta_page.exists?).to be_truthy

#     # execute - re-download
#     odds_trifecta_page.download_from_web!

#     # check
#     expect(odds_trifecta_page.valid?).to be_truthy
#     expect(odds_trifecta_page.exists?).to be_truthy

#     # execute - re-save
#     odds_trifecta_page.save!

#     # check
#     expect(odds_trifecta_page.valid?).to be_truthy
#     expect(odds_trifecta_page.exists?).to be_truthy
#   end

#   it "save: invalid" do
#     # execute - new invalid html
#     odds_trifecta_page = ScoringHorseRacing::Rule::OddsTrifectaPage.new("0000000000", nil, "Invalid html", @downloader, @repo)

#     # check
#     expect(odds_trifecta_page.valid?).to be_falsey
#     expect(odds_trifecta_page.exists?).to be_falsey

#     # execute - raised exception when save
#     expect { odds_trifecta_page.save! }.to raise_error "Invalid"

#     # check
#     expect(odds_trifecta_page.valid?).to be_falsey
#     expect(odds_trifecta_page.exists?).to be_falsey
#   end

# end
