RSpec.describe "schedule page spec" do

  before do
    repo = ScoringHorseRacing::SpecUtil.build_resource_repository
    repo.remove_s3_objects
  end

  it "download" do
    # execute - 過去月をインスタンス化
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(2018, 6, @downloader, @repo)

    # check
    assert_equal Time.new(2018, 6, 1), schedule_page.date
    assert_nil schedule_page.race_list_pages
    assert_not schedule_page.exists?
    assert_not schedule_page.valid?

    # execute - ダウンロード
    schedule_page.download_from_web!

    # check
    assert_equal 23, schedule_page.race_list_pages.length
    assert_not schedule_page.exists?
    assert schedule_page.valid?

    # execute - 保存
    schedule_page.save!

    # check
    assert_equal 23, schedule_page.race_list_pages.length
    assert schedule_page.exists?
    assert schedule_page.valid?

    # execute - 再インスタンス化
    schedule_page_2 = ScoringHorseRacing::Rule::SchedulePage.new(2018, 6, @downloader, @repo)

    # check
    assert_nil schedule_page_2.race_list_pages
    assert schedule_page_2.exists?
    assert_not schedule_page_2.valid?

    # execute - 再ダウンロードも可能
    schedule_page_2.download_from_s3!

    # check
    assert_equal 23, schedule_page_2.race_list_pages.length
    assert schedule_page_2.exists?
    assert schedule_page_2.valid?

    # execute - 再保存は上書き
    schedule_page_2.save!

    # check
    assert_equal 23, schedule_page_2.race_list_pages.length
    assert schedule_page_2.exists?
    assert schedule_page_2.valid?
  end

  it "download: 当月の場合" do
    # execute - 当月をインスタンス化
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(Time.now.year, Time.now.month, @downloader, @repo)

    # check
    assert_not schedule_page.exists?
    assert_not schedule_page.valid?

    # execute - ダウンロード
    schedule_page.download_from_web!

    # check
    assert_not schedule_page.exists?
    assert schedule_page.valid?

    # execute - 保存
    schedule_page.save!

    # check
    assert schedule_page.exists?
    assert schedule_page.valid?
  end

  it "download: 来月(リンクが不完全)の場合" do
    # setup
    html = File.open("spec/data/schedule.201808.html").read

    # execute - 当月をインスタンス化
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(2018, 8, html, @downloader, @repo)

    # check
    assert_not schedule_page.exists?
    assert schedule_page.valid?

    # execute - 保存
    schedule_page.save!

    # check
    assert schedule_page.exists?
    assert schedule_page.valid?
  end

  it "download: ページが存在しない月の場合" do
    # execute - 存在しない月をインスタンス化
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(1900, 1, @downloader, @repo)

    # check
    assert_not schedule_page.exists?
    assert_not schedule_page.valid?

    # execute - ダウンロード
    schedule_page.download_from_web!

    # check
    assert_not schedule_page.exists?
    assert_not schedule_page.valid?

    # execute - 保存
    assert_raises "Invalid" do
      schedule_page.save!
    end

    # check
    assert_not schedule_page.exists?
    assert_not schedule_page.valid?
  end

  it "parse" do
    # setup
    schedule_page_html = File.open("spec/data/schedule.201806.html").read
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(2018, 6, schedule_page_html, @downloader, @repo)

    # execute - 2018/6のスケジュールをパースして、レース一覧ページを取得する
    race_list_pages = schedule_page.race_list_pages

    # check
    assert schedule_page.valid?

    assert_equal 23, race_list_pages.length

    race_list_page = race_list_pages[0]
    assert_equal "18050301", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[1]
    assert_equal "18090301", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[2]
    assert_equal "18050302", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[3]
    assert_equal "18090302", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[4]
    assert_equal "18050303", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[5]
    assert_equal "18090303", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[6]
    assert_equal "18050304", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[7]
    assert_equal "18090304", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[8]
    assert_equal "18020101", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[9]
    assert_equal "18050305", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[10]
    assert_equal "18090305", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[11]
    assert_equal "18020102", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[12]
    assert_equal "18050306", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[13]
    assert_equal "18090306", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[14]
    assert_equal "18020103", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[15]
    assert_equal "18050307", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[16]
    assert_equal "18090307", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[17]
    assert_equal "18020104", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[18]
    assert_equal "18050308", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[19]
    assert_equal "18090308", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[20]
    assert_equal "18020105", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[21]
    assert_equal "18030201", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[22]
    assert_equal "18070301", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?
  end

  it "parse: case line skip" do
    # setup
    schedule_page_html = File.open("spec/data/schedule.201808.html").read
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(2018, 8, schedule_page_html, @downloader, @repo)

    # execute - 2018/8のスケジュール(一部のリンクが不完全)をパースして、レース一覧ページを取得する
    race_list_pages = schedule_page.race_list_pages

    # check
    assert schedule_page.valid?

    assert_equal 6, race_list_pages.length
 
    race_list_page = race_list_pages[0]
    assert_equal "18010103", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[1]
    assert_equal "18040203", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[2]
    assert_equal "18100203", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[3]
    assert_equal "18010104", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[4]
    assert_equal "18040204", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?

    race_list_page = race_list_pages[5]
    assert_equal "18100204", race_list_page.race_id
    assert_nil race_list_page.date
    assert_nil race_list_page.course_name
    assert_nil race_list_page.result_pages
    assert_not race_list_page.exists?
    assert_not race_list_page.valid?
  end

  it "parse: case invalid html" do
    # setup - 不正なHTMLでインスタンス化
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(1900, 1, "Invalid HTML")

    # check
    assert_equal Time.new(1900, 1, 1), schedule_page.date
    assert_nil schedule_page.race_list_pages
    assert_not schedule_page.valid?
  end

  it "save, and overwrite" do
    # execute - インスタンス化
    schedule_page_html = File.open("spec/data/schedule.201806.html").read
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(2018, 6, schedule_page_html)

    # check
    assert_not schedule_page.exists?
    assert schedule_page.valid?

    # execute - 保存
    schedule_page.save!

    # check
    assert schedule_page.exists?
    assert schedule_page.valid?

    # execute - 再ダウンロード
    schedule_page.download_from_web!

    # check
    assert schedule_page.exists?
    assert schedule_page.valid?

    # execute - 再保存
    schedule_page.save!

    # check
    assert schedule_page.exists?
    assert schedule_page.valid?
  end

  it "can't save: invalid" do
    # execute - 不正なHTMLをインスタンス化
    schedule_page = ScoringHorseRacing::Rule::SchedulePage.new(1900, 1, "Invalid html")

    # check
    assert_not schedule_page.exists?
    assert_not schedule_page.valid?

    # execute - 保存しようとして例外がスローされる
    assert_raises "Invalid" do
      schedule_page.save!
    end

    # check
    assert_not schedule_page.exists?
    assert_not schedule_page.valid?
  end

  it "same" do
    # setup - 比較するデータをインスタンス化
    schedule_page_1 = ScoringHorseRacing::Rule::SchedulePage.new(2018, 6, File.open("spec/data/schedule.201806.html").read)
    schedule_page_1.save!

    schedule_page_2 = ScoringHorseRacing::Rule::SchedulePage.new(2018, 6, File.open("spec/data/schedule.201806.html").read)
    schedule_page_2.save!

    schedule_page_3 = ScoringHorseRacing::Rule::SchedulePage.new(2018, 8, File.open("spec/data/schedule.201806.html").read)
    schedule_page_3.save!

    schedule_page_4 = ScoringHorseRacing::Rule::SchedulePage.new(2018, 8, File.open("spec/data/schedule.201808.html").read)
    schedule_page_4.save!

    # check
    assert schedule_page_1.same?(schedule_page_2)     # 同じデータはtrue
    assert_not schedule_page_2.same?(schedule_page_3) # 日付が異なるのでfalse
    assert_not schedule_page_3.same?(schedule_page_4) # コンテンツが異なるのでfalse
  end

end
