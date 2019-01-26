RSpec.describe "race list page spec" do

  before do
    @downloader = ScoringHorseRacing::SpecUtil.build_downloader

    @repo = ScoringHorseRacing::SpecUtil.build_resource_repository
    @repo.remove_s3_objects
  end

  it "download" do
    # setup
    schedule_page_html = File.open("spec/data/schedule.201806.html").read
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(2018, 6, schedule_page_html, @downloader, @repo)

    # execute
    race_list_pages = schedule_page.race_list_pages

    # check
    expect(race_list_pages.length).to eq 23

    race_list_page = race_list_pages[0]
    expect(race_list_page.race_id).to eq "18050301"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[1]
    expect(race_list_page.race_id).to eq "18090301"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[2]
    expect(race_list_page.race_id).to eq "18050302"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[3]
    expect(race_list_page.race_id).to eq "18090302"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[4]
    expect(race_list_page.race_id).to eq "18050303"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[5]
    expect(race_list_page.race_id).to eq "18090303"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[6]
    expect(race_list_page.race_id).to eq "18050304"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[7]
    expect(race_list_page.race_id).to eq "18090304"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[8]
    expect(race_list_page.race_id).to eq "18020101"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[9]
    expect(race_list_page.race_id).to eq "18050305"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[10]
    expect(race_list_page.race_id).to eq "18090305"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[11]
    expect(race_list_page.race_id).to eq "18020102"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[12]
    expect(race_list_page.race_id).to eq "18050306"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[13]
    expect(race_list_page.race_id).to eq "18090306"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[14]
    expect(race_list_page.race_id).to eq "18020103"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[15]
    expect(race_list_page.race_id).to eq "18050307"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[16]
    expect(race_list_page.race_id).to eq "18090307"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[17]
    expect(race_list_page.race_id).to eq "18020104"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[18]
    expect(race_list_page.race_id).to eq "18050308"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[19]
    expect(race_list_page.race_id).to eq "18090308"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[20]
    expect(race_list_page.race_id).to eq "18020105"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[21]
    expect(race_list_page.race_id).to eq "18030201"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[22]
    expect(race_list_page.race_id).to eq "18070301"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    # execute - download
    race_list_pages.each { |r| r.download_from_web! }

    # check
    race_list_pages.each do |race_list_page|
      expect(race_list_page.valid?).to be_truthy
      expect(race_list_page.exists?).to be_falsey
    end

    # execute - save
    race_list_pages.each { |r| r.save! }

    # check
    race_list_pages.each do |race_list_page|
      expect(race_list_page.exists?).to be_truthy
      expect(race_list_page.valid?).to be_truthy
    end

    # execute - re-instance
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(2018, 6, schedule_page_html, @downloader, @repo)
    race_list_pages_2 = schedule_page.race_list_pages

    # check
    expect(race_list_pages_2.length).to eq 23

    race_list_pages_2.each do |race_list_page_2|
      expect(race_list_page_2.exists?).to be_truthy
      expect(race_list_page_2.valid?).to be_falsey
    end

    # execute - re-download
    race_list_pages_2.each { |r| r.download_from_s3! }

    # check
    expect(race_list_pages_2.length).to eq 23

    race_list_pages_2.each do |race_list_page_2|
      expect(race_list_page_2.exists?).to be_truthy
      expect(race_list_page_2.valid?).to be_truthy

      race_list_page = race_list_pages.find { |r| r.race_id == race_list_page_2.race_id }

      expect(race_list_page_2.same?(race_list_page)).to be_truthy
    end

    # execute - overwrite
    race_list_pages_2.each { |r| r.save! }
  end

  it "download: case link skip" do
    # precondition
    schedule_page_html = File.open("spec/data/schedule.201808.html").read
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(2018, 8, schedule_page_html, @downloader, @repo)

    # execute
    race_list_pages = schedule_page.race_list_pages

    # postcondition
    expect(race_list_pages.length).to eq 6

    race_list_page = race_list_pages[0]
    expect(race_list_page.race_id).to eq "18010103"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[1]
    expect(race_list_page.race_id).to eq "18040203"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[2]
    expect(race_list_page.race_id).to eq "18100203"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[3]
    expect(race_list_page.race_id).to eq "18010104"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[4]
    expect(race_list_page.race_id).to eq "18040204"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    race_list_page = race_list_pages[5]
    expect(race_list_page.race_id).to eq "18100204"
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    # execute - download
    race_list_pages.each { |r| r.download_from_web! }

    # check
    race_list_pages.each do |race_list_page|
      expect(race_list_page.valid?).to be_truthy
      expect(race_list_page.exists?).to be_falsey
    end

    # execute - save
    race_list_pages.each { |r| r.save! }

    # check
    race_list_pages.each do |race_list_page|
      expect(race_list_page.exists?).to be_truthy
      expect(race_list_page.valid?).to be_truthy
    end

    # execute - re-instance
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(2018, 8, schedule_page_html, @downloader, @repo)
    race_list_pages_2 = schedule_page.race_list_pages

    # check
    expect(race_list_pages_2.length).to eq 6

    race_list_pages_2.each do |race_list_page_2|
      expect(race_list_page_2.exists?).to be_truthy
      expect(race_list_page_2.valid?).to be_falsey
    end

    # execute - re-download
    race_list_pages_2.each { |r| r.download_from_s3! }

    # check
    expect(race_list_pages_2.length).to eq 6

    race_list_pages_2.each do |race_list_page_2|
      expect(race_list_page_2.exists?).to be_truthy
      expect(race_list_page_2.valid?).to be_truthy

      race_list_page = race_list_pages.find { |r| r.race_id == race_list_page_2.race_id }

      expect(race_list_page_2.same?(race_list_page)).to be_truthy
    end

    # execute - overwrite
    race_list_pages_2.each { |r| r.save! }
  end

  it "download: case invalid html" do
    # execute
    race_list_page = ScoringHorseRacing::Rule::RaceListPage.new("00000000", nil, @downloader, @repo)

    # check
    expect(race_list_page.race_id).to eq "00000000"
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    # execute
    race_list_page.download_from_web!

    # check
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    # execute
    expect { race_list_page.save! }.to raise_error "Invalid"

    # check
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey
  end

  it "parse" do
    # setup
    schedule_page_html = File.open("spec/data/schedule.201806.html").read
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(2018, 6, schedule_page_html, @downloader, @repo)

    race_list_page_html = File.open("spec/data/race_list.20180624.hanshin.html").read

    # execute
    race_list_page = ScoringHorseRacing::Rule::RaceListPage.new("18090308", race_list_page_html, @downloader, @repo)

    # check
    expect(race_list_page.race_id).to eq "18090308"
    expect(race_list_page.date).to eq Time.new(2018, 6, 24)
    expect(race_list_page.course_name).to eq "阪神"
    expect(race_list_page.valid?).to be_truthy

    expect(race_list_page.result_pages.length).to eq 12

    result_page = race_list_page.result_pages[0]
    expect(result_page.result_id).to eq "1809030801"
    expect(result_page.race_number).to be nil
    expect(result_page.race_name).to be nil
    expect(result_page.start_datetime).to be nil
    expect(result_page.entry_page).to be nil
    expect(result_page.odds_win_page).to be nil
    expect(result_page.valid?).to be_falsey
    expect(result_page.exists?).to be_falsey

    result_page = race_list_page.result_pages[1]
    expect(result_page.result_id).to eq "1809030802"
    expect(result_page.race_number).to be nil
    expect(result_page.race_name).to be nil
    expect(result_page.start_datetime).to be nil
    expect(result_page.entry_page).to be nil
    expect(result_page.odds_win_page).to be nil
    expect(result_page.valid?).to be_falsey
    expect(result_page.exists?).to be_falsey

    result_page = race_list_page.result_pages[2]
    expect(result_page.result_id).to eq "1809030803"
    expect(result_page.race_number).to be nil
    expect(result_page.race_name).to be nil
    expect(result_page.start_datetime).to be nil
    expect(result_page.entry_page).to be nil
    expect(result_page.odds_win_page).to be nil
    expect(result_page.valid?).to be_falsey
    expect(result_page.exists?).to be_falsey

    result_page = race_list_page.result_pages[3]
    expect(result_page.result_id).to eq "1809030804"
    expect(result_page.race_number).to be nil
    expect(result_page.race_name).to be nil
    expect(result_page.start_datetime).to be nil
    expect(result_page.entry_page).to be nil
    expect(result_page.odds_win_page).to be nil
    expect(result_page.valid?).to be_falsey
    expect(result_page.exists?).to be_falsey

    result_page = race_list_page.result_pages[4]
    expect(result_page.result_id).to eq "1809030805"
    expect(result_page.race_number).to be nil
    expect(result_page.race_name).to be nil
    expect(result_page.start_datetime).to be nil
    expect(result_page.entry_page).to be nil
    expect(result_page.odds_win_page).to be nil
    expect(result_page.valid?).to be_falsey
    expect(result_page.exists?).to be_falsey

    result_page = race_list_page.result_pages[5]
    expect(result_page.result_id).to eq "1809030806"
    expect(result_page.race_number).to be nil
    expect(result_page.race_name).to be nil
    expect(result_page.start_datetime).to be nil
    expect(result_page.entry_page).to be nil
    expect(result_page.odds_win_page).to be nil
    expect(result_page.valid?).to be_falsey
    expect(result_page.exists?).to be_falsey

    result_page = race_list_page.result_pages[6]
    expect(result_page.result_id).to eq "1809030807"
    expect(result_page.race_number).to be nil
    expect(result_page.race_name).to be nil
    expect(result_page.start_datetime).to be nil
    expect(result_page.entry_page).to be nil
    expect(result_page.odds_win_page).to be nil
    expect(result_page.valid?).to be_falsey
    expect(result_page.exists?).to be_falsey

    result_page = race_list_page.result_pages[7]
    expect(result_page.result_id).to eq "1809030808"
    expect(result_page.race_number).to be nil
    expect(result_page.race_name).to be nil
    expect(result_page.start_datetime).to be nil
    expect(result_page.entry_page).to be nil
    expect(result_page.odds_win_page).to be nil
    expect(result_page.valid?).to be_falsey
    expect(result_page.exists?).to be_falsey

    result_page = race_list_page.result_pages[8]
    expect(result_page.result_id).to eq "1809030809"
    expect(result_page.race_number).to be nil
    expect(result_page.race_name).to be nil
    expect(result_page.start_datetime).to be nil
    expect(result_page.entry_page).to be nil
    expect(result_page.odds_win_page).to be nil
    expect(result_page.valid?).to be_falsey
    expect(result_page.exists?).to be_falsey

    result_page = race_list_page.result_pages[9]
    expect(result_page.result_id).to eq "1809030810"
    expect(result_page.race_number).to be nil
    expect(result_page.race_name).to be nil
    expect(result_page.start_datetime).to be nil
    expect(result_page.entry_page).to be nil
    expect(result_page.odds_win_page).to be nil
    expect(result_page.valid?).to be_falsey
    expect(result_page.exists?).to be_falsey

    result_page = race_list_page.result_pages[10]
    expect(result_page.result_id).to eq "1809030811"
    expect(result_page.race_number).to be nil
    expect(result_page.race_name).to be nil
    expect(result_page.start_datetime).to be nil
    expect(result_page.entry_page).to be nil
    expect(result_page.odds_win_page).to be nil
    expect(result_page.valid?).to be_falsey
    expect(result_page.exists?).to be_falsey

    result_page = race_list_page.result_pages[11]
    expect(result_page.result_id).to eq "1809030812"
    expect(result_page.race_number).to be nil
    expect(result_page.race_name).to be nil
    expect(result_page.start_datetime).to be nil
    expect(result_page.entry_page).to be nil
    expect(result_page.odds_win_page).to be nil
    expect(result_page.valid?).to be_falsey
    expect(result_page.exists?).to be_falsey
  end

  it "parse: case invalid html" do
    # setup
    schedule_page_html = File.open("spec/data/schedule.201808.html").read
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(2018, 8, schedule_page_html, @downloader, @repo)

    # execute
    race_list_page = ScoringHorseRacing::Rule::RaceListPage.new("aaaaaaaaaa", "Invalid html", @downloader, @repo)

    # postcondition
    expect(race_list_page.race_id).to eq "aaaaaaaaaa"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
  end

  it "save, and overwrite" do
    # setup
    schedule_page_html = File.open("spec/data/schedule.201806.html").read
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(2018, 6, schedule_page_html, @downloader, @repo)

    race_list_page_html = File.open("spec/data/race_list.20180624.hanshin.html").read

    # execute - インスタンス化 & パース
    race_list_page = ScoringHorseRacing::Rule::RaceListPage.new("18090308", race_list_page_html, @downloader, @repo)

    # check
    expect(race_list_page.race_id).to eq "18090308"
    expect(race_list_page.date).to eq Time.new(2018, 6, 24)
    expect(race_list_page.course_name).to eq "阪神"
    expect(race_list_page.result_pages.length).to eq 12
    expect(race_list_page.valid?).to be_truthy
    expect(race_list_page.exists?).to be_falsey

    # execute - 保存
    race_list_page.save!

    # check
    expect(race_list_page.valid?).to be_truthy
    expect(race_list_page.exists?).to be_truthy

    # execute - 再ダウンロード
    race_list_page.download_from_web!

    # check
    expect(race_list_page.valid?).to be_truthy
    expect(race_list_page.exists?).to be_truthy

    # execute - 再保存
    race_list_page.save!

    # check
    expect(race_list_page.valid?).to be_truthy
    expect(race_list_page.exists?).to be_truthy
  end

  it "can't save: invalid" do
    # setup
    schedule_page_html = File.open("spec/data/schedule.201806.html").read
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(2018, 6, schedule_page_html, @downloader, @repo)

    # execute - 不正なHTMLをインスタンス化
    race_list_page = ScoringHorseRacing::Rule::RaceListPage.new("aaaaaaaa", "Invalid html", @downloader, @repo)

    # check
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey

    # execute - 保存しようとして例外がスローされる
    expect { race_list_page.save! }.to raise_error "Invalid"

    # check
    expect(race_list_page.valid?).to be_falsey
    expect(race_list_page.exists?).to be_falsey
  end

end
