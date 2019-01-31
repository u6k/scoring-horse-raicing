# RSpec.describe "entry page spec" do

#   before do
#     @downloader = ScoringHorseRacing::SpecUtil.build_downloader

#     @repo = ScoringHorseRacing::SpecUtil.build_resource_repository
#     @repo.remove_s3_objects
#   end

#   it "download" do
#     # setup
#     result_page_html = File.open("spec/data/result.20180624.hanshin.1.html").read
#     result_page = ScoringHorseRacing::Rule::ResultPage.new("1809030801", result_page_html, @downloader, @repo)

#     # execute - インスタンス化
#     entry_page = result_page.entry_page

#     # check
#     expect(entry_page.entry_id).to eq("1809030801")
#     expect(entry_page.entries).to be nil
#     expect(entry_page.valid?).to be_falsey
#     expect(entry_page.exists?).to be_falsey

#     # execute - ダウンロード
#     entry_page.download_from_web!

#     # check
#     expect(entry_page.entry_id).to eq("1809030801")
#     expect(entry_page.entries.length).to eq(16)
#     expect(entry_page.valid?).to be_truthy
#     expect(entry_page.exists?).to be_falsey

#     # execute - 保存
#     entry_page.save!

#     # check
#     expect(entry_page.valid?).to be_truthy
#     expect(entry_page.exists?).to be_truthy

#     # execute - 再インスタンス化
#     result_page = ScoringHorseRacing::Rule::ResultPage.new("1809030801", result_page_html, @downloader, @repo)
#     entry_page_2 = result_page.entry_page

#     # check
#     expect(entry_page_2.entry_id).to eq("1809030801")
#     expect(entry_page_2.entries).to be nil
#     expect(entry_page_2.valid?).to be_falsey
#     expect(entry_page_2.exists?).to be_truthy

#     # execute - 再ダウンロード
#     entry_page_2.download_from_s3!

#     # check
#     expect(entry_page_2.entry_id).to eq("1809030801")
#     expect(entry_page_2.entries.length).to eq(16)
#     expect(entry_page_2.valid?).to be_truthy
#     expect(entry_page_2.exists?).to be_truthy

#     # execute - 上書き保存
#     entry_page_2.save!
#   end

#   it "download: case invalid html" do
#     # execute - 不正なエントリーIDのページをインスタンス化
#     entry_page = ScoringHorseRacing::Rule::EntryPage.new("0000000000", nil, @downloader, @repo)

#     # check
#     expect(entry_page.entry_id).to eq("0000000000")
#     expect(entry_page.entries).to be nil
#     expect(entry_page.valid?).to be_falsey
#     expect(entry_page.exists?).to be_falsey

#     # execute - ダウンロード -> 失敗
#     entry_page.download_from_web!

#     # check
#     expect(entry_page.entry_id).to eq "0000000000"
#     expect(entry_page.entries).to be nil
#     expect(entry_page.valid?).to be_falsey
#     expect(entry_page.exists?).to be_falsey

#     # execute - 保存 -> 失敗
#     expect { entry_page.save! }.to raise_error "Invalid"

#     # check
#     expect(entry_page.valid?).to be_falsey
#     expect(entry_page.exists?).to be_falsey
#   end

#   it "parse" do
#     # setup
#     entry_page_html = File.open("spec/data/entry.20180624.hanshin.1.html").read

#     # execute
#     entry_page = ScoringHorseRacing::Rule::EntryPage.new("1809030801", entry_page_html, @downloader, @repo)

#     # check
#     expect(entry_page.entry_id).to eq "1809030801"
#     expect(entry_page.entries.length).to eq 16
#     expect(entry_page.valid?).to be_truthy
#     expect(entry_page.exists?).to be_falsey

#     entry = entry_page.entries[0]
#     expect(entry[:bracket_number]).to eq 1
#     expect(entry[:horse_number]).to eq 1
#     expect(entry[:horse].horse_id).to eq "2015104308"
#     expect(entry[:trainer].trainer_id).to eq "01120"
#     expect(entry[:jockey].jockey_id).to eq "05339"

#     entry = entry_page.entries[1]
#     expect(entry[:bracket_number]).to eq 1
#     expect(entry[:horse_number]).to eq 2
#     expect(entry[:horse].horse_id).to eq "2015104964"
#     expect(entry[:trainer].trainer_id).to eq "01022"
#     expect(entry[:jockey].jockey_id).to eq "01014"

#     entry = entry_page.entries[2]
#     expect(entry[:bracket_number]).to eq 2
#     expect(entry[:horse_number]).to eq 3
#     expect(entry[:horse].horse_id).to eq "2015100632"
#     expect(entry[:trainer].trainer_id).to eq "01046"
#     expect(entry[:jockey].jockey_id).to eq "01088"

#     entry = entry_page.entries[3]
#     expect(entry[:bracket_number]).to eq 2
#     expect(entry[:horse_number]).to eq 4
#     expect(entry[:horse].horse_id).to eq "2015100586"
#     expect(entry[:trainer].trainer_id).to eq "01140"
#     expect(entry[:jockey].jockey_id).to eq "01114"

#     entry = entry_page.entries[4]
#     expect(entry[:bracket_number]).to eq 3
#     expect(entry[:horse_number]).to eq 5
#     expect(entry[:horse].horse_id).to eq "2015103335"
#     expect(entry[:trainer].trainer_id).to eq "01041"
#     expect(entry[:jockey].jockey_id).to eq "01165"

#     entry = entry_page.entries[5]
#     expect(entry[:bracket_number]).to eq 3
#     expect(entry[:horse_number]).to eq 6
#     expect(entry[:horse].horse_id).to eq "2015104928"
#     expect(entry[:trainer].trainer_id).to eq "01073"
#     expect(entry[:jockey].jockey_id).to eq "00894"

#     entry = entry_page.entries[6]
#     expect(entry[:bracket_number]).to eq 4
#     expect(entry[:horse_number]).to eq 7
#     expect(entry[:horse].horse_id).to eq "2015106259"
#     expect(entry[:trainer].trainer_id).to eq "01078"
#     expect(entry[:jockey].jockey_id).to eq "01034"

#     entry = entry_page.entries[7]
#     expect(entry[:bracket_number]).to eq 4
#     expect(entry[:horse_number]).to eq 8
#     expect(entry[:horse].horse_id).to eq "2015102694"
#     expect(entry[:trainer].trainer_id).to eq "01104"
#     expect(entry[:jockey].jockey_id).to eq "05203"

#     entry = entry_page.entries[8]
#     expect(entry[:bracket_number]).to eq 5
#     expect(entry[:horse_number]).to eq 9
#     expect(entry[:horse].horse_id).to eq "2015102837"
#     expect(entry[:trainer].trainer_id).to eq "01050"
#     expect(entry[:jockey].jockey_id).to eq "01126"

#     entry = entry_page.entries[9]
#     expect(entry[:bracket_number]).to eq 5
#     expect(entry[:horse_number]).to eq 10
#     expect(entry[:horse].horse_id).to eq "2015105363"
#     expect(entry[:trainer].trainer_id).to eq "01138"
#     expect(entry[:jockey].jockey_id).to eq "01019"

#     entry = entry_page.entries[10]
#     expect(entry[:bracket_number]).to eq 6
#     expect(entry[:horse_number]).to eq 11
#     expect(entry[:horse].horse_id).to eq "2015101618"
#     expect(entry[:trainer].trainer_id).to eq "01066"
#     expect(entry[:jockey].jockey_id).to eq "01166"

#     entry = entry_page.entries[11]
#     expect(entry[:bracket_number]).to eq 6
#     expect(entry[:horse_number]).to eq 12
#     expect(entry[:horse].horse_id).to eq "2015102853"
#     expect(entry[:trainer].trainer_id).to eq "01111"
#     expect(entry[:jockey].jockey_id).to eq "01018"

#     entry = entry_page.entries[12]
#     expect(entry[:bracket_number]).to eq 7
#     expect(entry[:horse_number]).to eq 13
#     expect(entry[:horse].horse_id).to eq "2015103462"
#     expect(entry[:trainer].trainer_id).to eq "00356"
#     expect(entry[:jockey].jockey_id).to eq "01130"

#     entry = entry_page.entries[13]
#     expect(entry[:bracket_number]).to eq 7
#     expect(entry[:horse_number]).to eq 14
#     expect(entry[:horse].horse_id).to eq "2015103590"
#     expect(entry[:trainer].trainer_id).to eq "01157"
#     expect(entry[:jockey].jockey_id).to eq "05386"

#     entry = entry_page.entries[14]
#     expect(entry[:bracket_number]).to eq 8
#     expect(entry[:horse_number]).to eq 15
#     expect(entry[:horse].horse_id).to eq "2015104979"
#     expect(entry[:trainer].trainer_id).to eq "00438"
#     expect(entry[:jockey].jockey_id).to eq "01116"

#     entry = entry_page.entries[15]
#     expect(entry[:bracket_number]).to eq 8
#     expect(entry[:horse_number]).to eq 16
#     expect(entry[:horse].horse_id).to eq "2015103557"
#     expect(entry[:trainer].trainer_id).to eq "01022"
#     expect(entry[:jockey].jockey_id).to eq "01154"
#   end

#   it "parse: invalid html" do
#     # execute
#     entry_page = ScoringHorseRacing::Rule::EntryPage.new("0000000000", "Invalid html", @downloader, @repo)

#     # check
#     expect(entry_page.entry_id).to eq "0000000000"
#     expect(entry_page.entries).to be nil
#     expect(entry_page.valid?).to be_falsey
#     expect(entry_page.exists?).to be_falsey
#   end

#   it "save, and overwrite" do
#     # setup
#     entry_page_html = File.open("spec/data/entry.20180624.hanshin.1.html").read

#     # execute - インスタンス化 & パース
#     entry_page = ScoringHorseRacing::Rule::EntryPage.new("1809030801", entry_page_html, @downloader, @repo)

#     # check
#     expect(entry_page.entry_id).to eq "1809030801"
#     expect(entry_page.entries.length).to eq 16
#     expect(entry_page.valid?).to be_truthy
#     expect(entry_page.exists?).to be_falsey

#     # execute - 保存
#     entry_page.save!

#     # check
#     expect(entry_page.valid?).to be_truthy
#     expect(entry_page.exists?).to be_truthy

#     # execute - 再ダウンロード
#     entry_page.download_from_web!

#     # check
#     expect(entry_page.valid?).to be_truthy
#     expect(entry_page.exists?).to be_truthy

#     # execute - 上書き保存
#     entry_page.save!

#     # check
#     expect(entry_page.valid?).to be_truthy
#     expect(entry_page.exists?).to be_truthy
#   end

#   it "save: invalid" do
#     # execute - インスタンス化 && ダウンロード && パース -> 失敗
#     entry_page = ScoringHorseRacing::Rule::EntryPage.new("0000000000", "Invalid html", @downloader, @repo)

#     # check
#     expect(entry_page.entry_id).to eq "0000000000"
#     expect(entry_page.entries).to be nil
#     expect(entry_page.valid?).to be_falsey
#     expect(entry_page.exists?).to be_falsey

#     # execute - 保存しようとして例外がスローされる
#     expect { entry_page.save! }.to raise_error "Invalid"

#     # check
#     expect(entry_page.valid?).to be_falsey
#     expect(entry_page.exists?).to be_falsey
#   end

# end
