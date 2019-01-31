# RSpec.describe "result page spec" do

#   before do
#     @downloader = ScoringHorseRacing::SpecUtil.build_downloader

#     @repo = ScoringHorseRacing::SpecUtil.build_resource_repository
#     @repo.remove_s3_objects
#   end

#   it "download" do
#     # setup
#     schedule_page_html = File.open("spec/data/schedule.201806.html").read
#     schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(2018, 6, schedule_page_html, @downloader, @repo)

#     race_list_page_html = File.open("spec/data/race_list.20180624.hanshin.html").read
#     race_list_page = ScoringHorseRacing::Rule::RaceListPage.new("18090308", race_list_page_html, @downloader, @repo)

#     # execute - インスタンス化
#     result_pages = race_list_page.result_pages

#     # check
#     expect(result_pages.length).to eq 12

#     expect(result_pages[0].result_id).to eq "1809030801"
#     expect(result_pages[1].result_id).to eq "1809030802"
#     expect(result_pages[2].result_id).to eq "1809030803"
#     expect(result_pages[3].result_id).to eq "1809030804"
#     expect(result_pages[4].result_id).to eq "1809030805"
#     expect(result_pages[5].result_id).to eq "1809030806"
#     expect(result_pages[6].result_id).to eq "1809030807"
#     expect(result_pages[7].result_id).to eq "1809030808"
#     expect(result_pages[8].result_id).to eq "1809030809"
#     expect(result_pages[9].result_id).to eq "1809030810"
#     expect(result_pages[10].result_id).to eq "1809030811"
#     expect(result_pages[11].result_id).to eq "1809030812"

#     result_pages.each do |result_page|
#       expect(result_page.race_number).to be nil
#       expect(result_page.race_name).to be nil
#       expect(result_page.start_datetime).to be nil
#       expect(result_page.entry_page).to be nil
#       expect(result_page.odds_win_page).to be nil
#       expect(result_page.valid?).to be_falsey
#       expect(result_page.exists?).to be_falsey
#     end

#     # execute - ダウンロード
#     result_pages.each { |r| r.download_from_web! }

#     # check
#     expect(result_pages.length).to eq 12

#     result_page = result_pages[0]
#     expect(result_page.result_id).to eq "1809030801"
#     expect(result_page.race_number).to eq 1
#     expect(result_page.start_datetime).to eq Time.new(2018, 6, 24, 10, 5, 0)
#     expect(result_page.race_name).to eq "サラ系3歳未勝利"

#     result_page = result_pages[1]
#     expect(result_page.result_id).to eq "1809030802"
#     expect(result_page.race_number).to eq 2
#     expect(result_page.start_datetime).to eq Time.new(2018, 6, 24, 10, 35, 0)
#     expect(result_page.race_name).to eq "サラ系3歳未勝利"

#     result_page = result_pages[2]
#     expect(result_page.result_id).to eq "1809030803"
#     expect(result_page.race_number).to eq 3
#     expect(result_page.start_datetime).to eq Time.new(2018, 6, 24, 11, 5, 0)
#     expect(result_page.race_name).to eq "サラ系3歳未勝利"

#     result_page = result_pages[3]
#     expect(result_page.result_id).to eq "1809030804"
#     expect(result_page.race_number).to eq 4
#     expect(result_page.start_datetime).to eq Time.new(2018, 6, 24, 11, 35, 0)
#     expect(result_page.race_name).to eq "サラ系3歳未勝利"

#     result_page = result_pages[4]
#     expect(result_page.result_id).to eq "1809030805"
#     expect(result_page.race_number).to eq 5
#     expect(result_page.start_datetime).to eq Time.new(2018, 6, 24, 12, 25, 0)
#     expect(result_page.race_name).to eq "サラ系2歳新馬"

#     result_page = result_pages[5]
#     expect(result_page.result_id).to eq "1809030806"
#     expect(result_page.race_number).to eq 6
#     expect(result_page.start_datetime).to eq Time.new(2018, 6, 24, 12, 55, 0)
#     expect(result_page.race_name).to eq "サラ系3歳上500万円以下"

#     result_page = result_pages[6]
#     expect(result_page.result_id).to eq "1809030807"
#     expect(result_page.race_number).to eq 7
#     expect(result_page.start_datetime).to eq Time.new(2018, 6, 24, 13, 25, 0)
#     expect(result_page.race_name).to eq "サラ系3歳上500万円以下"

#     result_page = result_pages[7]
#     expect(result_page.result_id).to eq "1809030808"
#     expect(result_page.race_number).to eq 8
#     expect(result_page.start_datetime).to eq Time.new(2018, 6, 24, 13, 55, 0)
#     expect(result_page.race_name).to eq "出石特別"

#     result_page = result_pages[8]
#     expect(result_page.result_id).to eq "1809030809"
#     expect(result_page.race_number).to eq 9
#     expect(result_page.start_datetime).to eq Time.new(2018, 6, 24, 14, 25, 0)
#     expect(result_page.race_name).to eq "皆生特別"

#     result_page = result_pages[9]
#     expect(result_page.result_id).to eq "1809030810"
#     expect(result_page.race_number).to eq 10
#     expect(result_page.start_datetime).to eq Time.new(2018, 6, 24, 15, 1, 0)
#     expect(result_page.race_name).to eq "花のみちステークス"

#     result_page = result_pages[10]
#     expect(result_page.result_id).to eq "1809030811"
#     expect(result_page.race_number).to eq 11
#     expect(result_page.start_datetime).to eq Time.new(2018, 6, 24, 15, 40, 0)
#     expect(result_page.race_name).to eq "第59回宝塚記念（GI）"

#     result_page = result_pages[11]
#     expect(result_page.result_id).to eq "1809030812"
#     expect(result_page.race_number).to eq 12
#     expect(result_page.start_datetime).to eq Time.new(2018, 6, 24, 16, 30, 0)
#     expect(result_page.race_name).to eq "リボン賞"

#     result_pages.each do |result_page|
#       expect(result_page.valid?).to be_truthy
#       expect(result_page.exists?).to be_falsey
#     end

#     # execute - 保存
#     result_pages.each { |r| r.save! }

#     # check
#     result_pages.each do |result_page|
#       expect(result_page.valid?).to be_truthy
#       expect(result_page.exists?).to be_truthy
#     end

#     # execute - 再インスタンス化
#     schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(2018, 6, schedule_page_html, @downloader, @repo)
#     race_list_page = ScoringHorseRacing::Rule::RaceListPage.new("18090308", race_list_page_html, @downloader, @repo)
#     result_pages_2 = race_list_page.result_pages

#     # check
#     expect(result_pages_2.length).to eq 12

#     expect(result_pages_2[0].result_id).to eq "1809030801"
#     expect(result_pages_2[1].result_id).to eq "1809030802"
#     expect(result_pages_2[2].result_id).to eq "1809030803"
#     expect(result_pages_2[3].result_id).to eq "1809030804"
#     expect(result_pages_2[4].result_id).to eq "1809030805"
#     expect(result_pages_2[5].result_id).to eq "1809030806"
#     expect(result_pages_2[6].result_id).to eq "1809030807"
#     expect(result_pages_2[7].result_id).to eq "1809030808"
#     expect(result_pages_2[8].result_id).to eq "1809030809"
#     expect(result_pages_2[9].result_id).to eq "1809030810"
#     expect(result_pages_2[10].result_id).to eq "1809030811"
#     expect(result_pages[11].result_id).to eq "1809030812"

#     result_pages_2.each do |result_page_2|
#       expect(result_page_2.race_number).to be nil
#       expect(result_page_2.race_name).to be nil
#       expect(result_page_2.start_datetime).to be nil
#       expect(result_page_2.entry_page).to be nil
#       expect(result_page_2.odds_win_page).to be nil
#       expect(result_page_2.valid?).to be_falsey
#       expect(result_page_2.exists?).to be_truthy
#     end

#     # execute - 再ダウンロード
#     result_pages_2.each { |r| r.download_from_s3! }

#     # check
#     result_pages_2.each do |result_page_2|
#       expect(result_page_2.valid?).to be_truthy
#       expect(result_page_2.exists?).to be_truthy

#       result_page = result_pages.find { |r| r.result_id == result_page_2.result_id }
#       result_page_2.same?(result_page)
#     end

#     # execute - 上書き保存
#     result_pages_2.each { |r| r.save! }
#   end

#   it "download: case invalid html" do
#     # execute - 不正なレースIDのページをインスタンス化
#     result_page = ScoringHorseRacing::Rule::ResultPage.new("0000000000", nil, @downloader, @repo)

#     # check
#     expect(result_page.result_id).to eq "0000000000"
#     expect(result_page.valid?).to be_falsey
#     expect(result_page.exists?).to be_falsey

#     # execute - ダウンロード -> 失敗
#     result_page.download_from_web!

#     # check
#     expect(result_page.result_id).to eq "0000000000"
#     expect(result_page.valid?).to be_falsey
#     expect(result_page.exists?).to be_falsey

#     # execute - 保存 -> 失敗
#     expect { result_page.save! }.to raise_error "Invalid"

#     # check
#     expect(result_page.result_id).to eq "0000000000"
#     expect(result_page.valid?).to be_falsey
#     expect(result_page.exists?).to be_falsey
#   end

#   it "parse" do
#     # setup
#     result_html = File.open("spec/data/result.20180624.hanshin.1.html").read

#     # execute
#     result_page = ScoringHorseRacing::Rule::ResultPage.new("1809030801", result_html, @downloader, @repo)

#     # check
#     expect(result_page.result_id).to eq "1809030801"
#     expect(result_page.race_number).to eq 1
#     expect(result_page.start_datetime).to eq Time.new(2018, 6, 24, 10, 5, 0)
#     expect(result_page.race_name).to eq "サラ系3歳未勝利"
#     expect(result_page.entry_page.entry_id).to eq "1809030801"
#     expect(result_page.odds_win_page.odds_id).to eq "1809030801"
#     expect(result_page.valid?).to be_truthy
#     expect(result_page.exists?).to be_falsey
#   end

#   it "parse: missing link" do
#     # setup
#     result_html = File.open("spec/data/result.19860126.tyukyou.11.html").read

#     # execute
#     result_page = ScoringHorseRacing::Rule::ResultPage.new("8607010211", result_html, @downloader, @repo)

#     # check
#     expect(result_page.result_id).to eq "8607010211"
#     expect(result_page.race_number).to eq 11
#     expect(result_page.start_datetime).to eq Time.new(1986, 1, 26, 15, 35, 0)
#     expect(result_page.race_name).to eq "中京スポーツ杯"
#     expect(result_page.entry_page).to be nil
#     expect(result_page.odds_win_page).to be nil
#     expect(result_page.valid?).to be_truthy
#     expect(result_page.exists?).to be_falsey
#   end

#   it "parse: case invalid html" do
#     # execute
#     result_page = ScoringHorseRacing::Rule::ResultPage.new("0000000000", nil, @downloader, @repo)
#     result_page.download_from_web!

#     # check
#     expect(result_page.result_id).to eq "0000000000"
#     expect(result_page.race_number).to be nil
#     expect(result_page.start_datetime).to be nil
#     expect(result_page.race_name).to be nil
#     expect(result_page.entry_page).to be nil
#     expect(result_page.odds_win_page).to be nil
#     expect(result_page.valid?).to be_falsey
#     expect(result_page.exists?).to be_falsey
#   end

#   it "save, and overwrite" do
#     # setup
#     result_html = File.open("spec/data/result.20180624.hanshin.1.html").read

#     # execute
#     result_page = ScoringHorseRacing::Rule::ResultPage.new("1809030801", result_html, @downloader, @repo)

#     # check
#     expect(result_page.result_id).to eq "1809030801"
#     expect(result_page.race_number).to eq 1
#     expect(result_page.start_datetime).to eq Time.new(2018, 6, 24, 10, 5, 0)
#     expect(result_page.race_name).to eq "サラ系3歳未勝利"
#     expect(result_page.entry_page.entry_id).to eq "1809030801"
#     expect(result_page.odds_win_page.odds_id).to eq "1809030801"
#     expect(result_page.valid?).to be_truthy
#     expect(result_page.exists?).to be_falsey

#     # execute - 保存
#     result_page.save!

#     # check
#     expect(result_page.valid?).to be_truthy
#     expect(result_page.exists?).to be_truthy

#     # execute - 再ダウンロード
#     result_page.download_from_web!

#     # check
#     expect(result_page.valid?).to be_truthy
#     expect(result_page.exists?).to be_truthy

#     # execute - 再保存
#     result_page.save!

#     # check
#     expect(result_page.valid?).to be_truthy
#     expect(result_page.exists?).to be_truthy
#   end

#   it "can't save: invalid" do
#     # execute - 不正なHTMLをインスタンス化
#     result_page = ScoringHorseRacing::Rule::ResultPage.new("0000000000", "Invalid html", @downloader, @repo)

#     # check
#     expect(result_page.valid?).to be_falsey
#     expect(result_page.exists?).to be_falsey

#     # execute - 保存しようとして例外がスローされる
#     expect { result_page.save! }.to raise_error "Invalid"

#     # check
#     expect(result_page.valid?).to be_falsey
#     expect(result_page.exists?).to be_falsey
#   end

# end
