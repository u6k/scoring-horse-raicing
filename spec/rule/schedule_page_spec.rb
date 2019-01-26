RSpec.describe "schedule page spec" do

  before do
    @downloader = ScoringHorseRacing::SpecUtil.build_downloader

    @repo = ScoringHorseRacing::SpecUtil.build_resource_repository
    @repo.remove_s3_objects
  end

  it "download" do
    # execute - 過去月をインスタンス化
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(2018, 6, nil, @downloader, @repo)

    # check
    expect(schedule_page.date).to eq Time.new(2018, 6, 1)
    expect(schedule_page.race_list_pages).to be nil
    expect(schedule_page.exists?).to be_falsey
    expect(schedule_page.valid?).to be_falsey

    # execute - ダウンロード
    schedule_page.download_from_web!

    # check
    expect(schedule_page.race_list_pages.length).to eq 23
    expect(schedule_page.exists?).to be_falsey
    expect(schedule_page.valid?).to be_truthy

    # execute - 保存
    schedule_page.save!

    # check
    expect(schedule_page.race_list_pages.length).to eq 23
    expect(schedule_page.exists?).to be_truthy
    expect(schedule_page.valid?).to be_truthy

    # execute - 再インスタンス化
    schedule_page_2 = ScoringHorseRacing::Rule::SchedulePage.new(2018, 6, nil, @downloader, @repo)

    # check
    expect(schedule_page_2.race_list_pages).to be nil
    expect(schedule_page_2.exists?).to be_truthy
    expect(schedule_page_2.valid?).to be_falsey

    # execute - 再ダウンロードも可能
    schedule_page_2.download_from_s3!

    # check
    expect(schedule_page_2.race_list_pages.length).to eq 23
    expect(schedule_page_2.exists?).to be_truthy
    expect(schedule_page_2.valid?).to be_truthy

    # execute - 再保存は上書き
    schedule_page_2.save!

    # check
    expect(schedule_page_2.race_list_pages.length).to eq 23
    expect(schedule_page_2.exists?).to be_truthy
    expect(schedule_page_2.valid?).to be_truthy
  end

  it "download: 当月の場合" do
    # execute - 当月をインスタンス化
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(Time.now.year, Time.now.month, nil, @downloader, @repo)

    # check
    expect(schedule_page.exists?).to be_falsey
    expect(schedule_page.valid?).to be_falsey

    # execute - ダウンロード
    schedule_page.download_from_web!

    # check
    expect(schedule_page.exists?).to be_falsey
    expect(schedule_page.valid?).to be_truthy

    # execute - 保存
    schedule_page.save!

    # check
    expect(schedule_page.exists?).to be_truthy
    expect(schedule_page.valid?).to be_truthy
  end

  it "download: 来月(リンクが不完全)の場合" do
    # setup
    html = File.open("spec/data/schedule.201808.html").read

    # execute - 当月をインスタンス化
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(2018, 8, html, @downloader, @repo)

    # check
    expect(schedule_page.exists?).to be_falsey
    expect(schedule_page.valid?).to be_truthy

    # execute - 保存
    schedule_page.save!

    # check
    expect(schedule_page.exists?).to be_truthy
    expect(schedule_page.valid?).to be_truthy
  end

  it "download: ページが存在しない月の場合" do
    # execute - 存在しない月をインスタンス化
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(1900, 1, nil, @downloader, @repo)

    # check
    expect(schedule_page.exists?).to be_falsey
    expect(schedule_page.valid?).to be_falsey

    # execute - ダウンロード
    schedule_page.download_from_web!

    # check
    expect(schedule_page.exists?).to be_falsey
    expect(schedule_page.valid?).to be_falsey

    # execute - 保存
    expect { schedule_page.save! }.to raise_error "Invalid"

    # check
    expect(schedule_page.exists?).to be_falsey
    expect(schedule_page.valid?).to be_falsey
  end

  it "parse" do
    # setup
    schedule_page_html = File.open("spec/data/schedule.201806.html").read
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(2018, 6, schedule_page_html, @downloader, @repo)

    # execute - 2018/6のスケジュールをパースして、レース一覧ページを取得する
    race_list_pages = schedule_page.race_list_pages

    # check
    expect(schedule_page.valid?).to be_truthy

    expect(race_list_pages.length).to eq 23

    race_list_page = race_list_pages[0]
    expect(race_list_page.race_id).to eq "18050301"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[1]
    expect(race_list_page.race_id).to eq "18090301"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[2]
    expect(race_list_page.race_id).to eq "18050302"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[3]
    expect(race_list_page.race_id).to eq "18090302"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[4]
    expect(race_list_page.race_id).to eq "18050303"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[5]
    expect(race_list_page.race_id).to eq "18090303"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[6]
    expect(race_list_page.race_id).to eq "18050304"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[7]
    expect(race_list_page.race_id).to eq "18090304"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[8]
    expect(race_list_page.race_id).to eq "18020101"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[9]
    expect(race_list_page.race_id).to eq "18050305"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[10]
    expect(race_list_page.race_id).to eq "18090305"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[11]
    expect(race_list_page.race_id).to eq "18020102"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[12]
    expect(race_list_page.race_id).to eq "18050306"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[13]
    expect(race_list_page.race_id).to eq "18090306"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[14]
    expect(race_list_page.race_id).to eq "18020103"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[15]
    expect(race_list_page.race_id).to eq "18050307"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[16]
    expect(race_list_page.race_id).to eq "18090307"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[17]
    expect(race_list_page.race_id).to eq "18020104"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[18]
    expect(race_list_page.race_id).to eq "18050308"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[19]
    expect(race_list_page.race_id).to eq "18090308"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[20]
    expect(race_list_page.race_id).to eq "18020105"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[21]
    expect(race_list_page.race_id).to eq "18030201"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[22]
    expect(race_list_page.race_id).to eq "18070301"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey
  end

  it "parse: case line skip" do
    # setup
    schedule_page_html = File.open("spec/data/schedule.201808.html").read
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(2018, 8, schedule_page_html, @downloader, @repo)

    # execute - 2018/8のスケジュール(一部のリンクが不完全)をパースして、レース一覧ページを取得する
    race_list_pages = schedule_page.race_list_pages

    # check
    expect(schedule_page.valid?).to be_truthy

    expect(race_list_pages.length).to eq 6
 
    race_list_page = race_list_pages[0]
    expect(race_list_page.race_id).to eq "18010103"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[1]
    expect(race_list_page.race_id).to eq "18040203"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[2]
    expect(race_list_page.race_id).to eq "18100203"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[3]
    expect(race_list_page.race_id).to eq "18010104"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[4]
    expect(race_list_page.race_id).to eq "18040204"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey

    race_list_page = race_list_pages[5]
    expect(race_list_page.race_id).to eq "18100204"
    expect(race_list_page.date).to be nil
    expect(race_list_page.course_name).to be nil
    expect(race_list_page.result_pages).to be nil
    expect(race_list_page.exists?).to be_falsey
    expect(race_list_page.valid?).to be_falsey
  end

  it "parse: case invalid html" do
    # setup - 不正なHTMLでインスタンス化
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(1900, 1, "Invalid HTML", @downloader, @repo)

    # check
    expect(schedule_page.date).to eq Time.new(1900, 1, 1)
    expect(schedule_page.race_list_pages).to be nil
    expect(schedule_page.valid?).to be_falsey
  end

  it "save, and overwrite" do
    # execute - インスタンス化
    schedule_page_html = File.open("spec/data/schedule.201806.html").read
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(2018, 6, schedule_page_html, @downloader, @repo)

    # check
    expect(schedule_page.exists?).to be_falsey
    expect(schedule_page.valid?).to be_truthy

    # execute - 保存
    schedule_page.save!

    # check
    expect(schedule_page.exists?).to be_truthy
    expect(schedule_page.valid?).to be_truthy

    # execute - 再ダウンロード
    schedule_page.download_from_web!

    # check
    expect(schedule_page.exists?).to be_truthy
    expect(schedule_page.valid?).to be_truthy

    # execute - 再保存
    schedule_page.save!

    # check
    expect(schedule_page.exists?).to be_truthy
    expect(schedule_page.valid?).to be_truthy
  end

  it "can't save: invalid" do
    # execute - 不正なHTMLをインスタンス化
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(1900, 1, "Invalid html", @downloader, @repo)

    # check
    expect(schedule_page.exists?).to be_falsey
    expect(schedule_page.valid?).to be_falsey

    # execute - 保存しようとして例外がスローされる
    expect { schedule_page.save! }.to raise_error "Invalid"

    # check
    expect(schedule_page.exists?).to be_falsey
    expect(schedule_page.valid?).to be_falsey
  end

  it "same" do
    # setup - 比較するデータをインスタンス化
    schedule_page_1 = ScoringHorseRacing::Rule::SchedulePage.new(2018, 6, File.open("spec/data/schedule.201806.html").read, @downloader, @repo)
    schedule_page_1.save!

    schedule_page_2 = ScoringHorseRacing::Rule::SchedulePage.new(2018, 6, File.open("spec/data/schedule.201806.html").read, @downloader, @repo)
    schedule_page_2.save!

    schedule_page_3 = ScoringHorseRacing::Rule::SchedulePage.new(2018, 8, File.open("spec/data/schedule.201806.html").read, @downloader, @repo)
    schedule_page_3.save!

    schedule_page_4 = ScoringHorseRacing::Rule::SchedulePage.new(2018, 8, File.open("spec/data/schedule.201808.html").read, @downloader, @repo)
    schedule_page_4.save!

    # check
    expect(schedule_page_1.same?(schedule_page_2)).to be_truthy
    expect(schedule_page_2.same?(schedule_page_3)).to be_falsey
    expect(schedule_page_3.same?(schedule_page_4)).to be_falsey
  end

end
