RSpec.describe "trainer page spec" do

  before do
    repo = build_resource_repository
    repo.remove_s3_objects
  end

  it "download" do
    # setup
    entry_page_html = File.open("test/fixtures/files/entry.20180624.hanshin.1.html").read
    entry_page = EntryPage.new("1809030801", entry_page_html)

    # execute - new
    entries = entry_page.entries

    # check
    assert_equal 16, entries.length

    trainer_page = entries[0][:trainer]
    assert_equal "01120", trainer_page.trainer_id
    assert_nil trainer_page.trainer_name
    assert_not trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[1][:trainer]
    assert_equal "01022", trainer_page.trainer_id
    assert_nil trainer_page.trainer_name
    assert_not trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[2][:trainer]
    assert_equal "01046", trainer_page.trainer_id
    assert_nil trainer_page.trainer_name
    assert_not trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[3][:trainer]
    assert_equal "01140", trainer_page.trainer_id
    assert_nil trainer_page.trainer_name
    assert_not trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[4][:trainer]
    assert_equal "01041", trainer_page.trainer_id
    assert_nil trainer_page.trainer_name
    assert_not trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[5][:trainer]
    assert_equal "01073", trainer_page.trainer_id
    assert_nil trainer_page.trainer_name
    assert_not trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[6][:trainer]
    assert_equal "01078", trainer_page.trainer_id
    assert_nil trainer_page.trainer_name
    assert_not trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[7][:trainer]
    assert_equal "01104", trainer_page.trainer_id
    assert_nil trainer_page.trainer_name
    assert_not trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[8][:trainer]
    assert_equal "01050", trainer_page.trainer_id
    assert_nil trainer_page.trainer_name
    assert_not trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[9][:trainer]
    assert_equal "01138", trainer_page.trainer_id
    assert_nil trainer_page.trainer_name
    assert_not trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[10][:trainer]
    assert_equal "01066", trainer_page.trainer_id
    assert_nil trainer_page.trainer_name
    assert_not trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[11][:trainer]
    assert_equal "01111", trainer_page.trainer_id
    assert_nil trainer_page.trainer_name
    assert_not trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[12][:trainer]
    assert_equal "00356", trainer_page.trainer_id
    assert_nil trainer_page.trainer_name
    assert_not trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[13][:trainer]
    assert_equal "01157", trainer_page.trainer_id
    assert_nil trainer_page.trainer_name
    assert_not trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[14][:trainer]
    assert_equal "00438", trainer_page.trainer_id
    assert_nil trainer_page.trainer_name
    assert_not trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[15][:trainer]
    assert_equal "01022", trainer_page.trainer_id
    assert_nil trainer_page.trainer_name
    assert_not trainer_page.valid?
    assert_not trainer_page.exists?

    # execute - ダウンロード
    entries.each { |e| e[:trainer].download_from_web! }

    # check
    assert_equal 16, entries.length

    trainer_page = entries[0][:trainer]
    assert_equal "01120", trainer_page.trainer_id
    assert_equal "千田 輝彦", trainer_page.trainer_name
    assert trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[1][:trainer]
    assert_equal "01022", trainer_page.trainer_id
    assert_equal "石坂 正", trainer_page.trainer_name
    assert trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[2][:trainer]
    assert_equal "01046", trainer_page.trainer_id
    assert_equal "鮫島 一歩", trainer_page.trainer_name
    assert trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[3][:trainer]
    assert_equal "01140", trainer_page.trainer_id
    assert_equal "石橋 守", trainer_page.trainer_name
    assert trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[4][:trainer]
    assert_equal "01041", trainer_page.trainer_id
    assert_equal "藤沢 則雄", trainer_page.trainer_name
    assert trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[5][:trainer]
    assert_equal "01073", trainer_page.trainer_id
    assert_equal "宮本 博", trainer_page.trainer_name
    assert trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[6][:trainer]
    assert_equal "01078", trainer_page.trainer_id
    assert_equal "北出 成人", trainer_page.trainer_name
    assert trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[7][:trainer]
    assert_equal "01104", trainer_page.trainer_id
    assert_equal "笹田 和秀", trainer_page.trainer_name
    assert trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[8][:trainer]
    assert_equal "01050", trainer_page.trainer_id
    assert_equal "飯田 雄三", trainer_page.trainer_name
    assert trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[9][:trainer]
    assert_equal "01138", trainer_page.trainer_id
    assert_equal "浜田 多実雄", trainer_page.trainer_name
    assert trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[10][:trainer]
    assert_equal "01066", trainer_page.trainer_id
    assert_equal "岡田 稲男", trainer_page.trainer_name
    assert trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[11][:trainer]
    assert_equal "01111", trainer_page.trainer_id
    assert_equal "鈴木 孝志", trainer_page.trainer_name
    assert trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[12][:trainer]
    assert_equal "00356", trainer_page.trainer_id
    assert_equal "坂口 正則", trainer_page.trainer_name
    assert trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[13][:trainer]
    assert_equal "01157", trainer_page.trainer_id
    assert_equal "杉山 晴紀", trainer_page.trainer_name
    assert trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[14][:trainer]
    assert_equal "00438", trainer_page.trainer_id
    assert_equal "安田 隆行", trainer_page.trainer_name
    assert trainer_page.valid?
    assert_not trainer_page.exists?

    trainer_page = entries[15][:trainer]
    assert_equal "01022", trainer_page.trainer_id
    assert_equal "石坂 正", trainer_page.trainer_name
    assert trainer_page.valid?
    assert_not trainer_page.exists?

    # execute - 保存
    entries.each { |e| e[:trainer].save! }

    # check
    entries.each do |e|
      assert e[:trainer].valid?
      assert e[:trainer].exists?
    end

    # execute - 再インスタンス化する
    entry_page = EntryPage.new("1809030801", entry_page_html)
    entries_2 = entry_page.entries

    # check
    assert_equal 16, entries_2.length

    trainer_page_2 = entries_2[0][:trainer]
    assert_equal "01120", trainer_page_2.trainer_id
    assert_nil trainer_page_2.trainer_name
    assert_not trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[1][:trainer]
    assert_equal "01022", trainer_page_2.trainer_id
    assert_nil trainer_page_2.trainer_name
    assert_not trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[2][:trainer]
    assert_equal "01046", trainer_page_2.trainer_id
    assert_nil trainer_page_2.trainer_name
    assert_not trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[3][:trainer]
    assert_equal "01140", trainer_page_2.trainer_id
    assert_nil trainer_page_2.trainer_name
    assert_not trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[4][:trainer]
    assert_equal "01041", trainer_page_2.trainer_id
    assert_nil trainer_page_2.trainer_name
    assert_not trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[5][:trainer]
    assert_equal "01073", trainer_page_2.trainer_id
    assert_nil trainer_page_2.trainer_name
    assert_not trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[6][:trainer]
    assert_equal "01078", trainer_page_2.trainer_id
    assert_nil trainer_page_2.trainer_name
    assert_not trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[7][:trainer]
    assert_equal "01104", trainer_page_2.trainer_id
    assert_nil trainer_page_2.trainer_name
    assert_not trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[8][:trainer]
    assert_equal "01050", trainer_page_2.trainer_id
    assert_nil trainer_page_2.trainer_name
    assert_not trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[9][:trainer]
    assert_equal "01138", trainer_page_2.trainer_id
    assert_nil trainer_page_2.trainer_name
    assert_not trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[10][:trainer]
    assert_equal "01066", trainer_page_2.trainer_id
    assert_nil trainer_page_2.trainer_name
    assert_not trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[11][:trainer]
    assert_equal "01111", trainer_page_2.trainer_id
    assert_nil trainer_page_2.trainer_name
    assert_not trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[12][:trainer]
    assert_equal "00356", trainer_page_2.trainer_id
    assert_nil trainer_page_2.trainer_name
    assert_not trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[13][:trainer]
    assert_equal "01157", trainer_page_2.trainer_id
    assert_nil trainer_page_2.trainer_name
    assert_not trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[14][:trainer]
    assert_equal "00438", trainer_page_2.trainer_id
    assert_nil trainer_page_2.trainer_name
    assert_not trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[15][:trainer]
    assert_equal "01022", trainer_page_2.trainer_id
    assert_nil trainer_page_2.trainer_name
    assert_not trainer_page_2.valid?
    assert trainer_page_2.exists?

    # execute - ダウンロード
    entries_2.each { |e| e[:trainer].download_from_s3! }

    # check
    assert_equal 16, entries_2.length

    trainer_page_2 = entries_2[0][:trainer]
    assert_equal "01120", trainer_page_2.trainer_id
    assert_equal "千田 輝彦", trainer_page_2.trainer_name
    assert trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[1][:trainer]
    assert_equal "01022", trainer_page_2.trainer_id
    assert_equal "石坂 正", trainer_page_2.trainer_name
    assert trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[2][:trainer]
    assert_equal "01046", trainer_page_2.trainer_id
    assert_equal "鮫島 一歩", trainer_page_2.trainer_name
    assert trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[3][:trainer]
    assert_equal "01140", trainer_page_2.trainer_id
    assert_equal "石橋 守", trainer_page_2.trainer_name
    assert trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[4][:trainer]
    assert_equal "01041", trainer_page_2.trainer_id
    assert_equal "藤沢 則雄", trainer_page_2.trainer_name
    assert trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[5][:trainer]
    assert_equal "01073", trainer_page_2.trainer_id
    assert_equal "宮本 博", trainer_page_2.trainer_name
    assert trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[6][:trainer]
    assert_equal "01078", trainer_page_2.trainer_id
    assert_equal "北出 成人", trainer_page_2.trainer_name
    assert trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[7][:trainer]
    assert_equal "01104", trainer_page_2.trainer_id
    assert_equal "笹田 和秀", trainer_page_2.trainer_name
    assert trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[8][:trainer]
    assert_equal "01050", trainer_page_2.trainer_id
    assert_equal "飯田 雄三", trainer_page_2.trainer_name
    assert trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[9][:trainer]
    assert_equal "01138", trainer_page_2.trainer_id
    assert_equal "浜田 多実雄", trainer_page_2.trainer_name
    assert trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[10][:trainer]
    assert_equal "01066", trainer_page_2.trainer_id
    assert_equal "岡田 稲男", trainer_page_2.trainer_name
    assert trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[11][:trainer]
    assert_equal "01111", trainer_page_2.trainer_id
    assert_equal "鈴木 孝志", trainer_page_2.trainer_name
    assert trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[12][:trainer]
    assert_equal "00356", trainer_page_2.trainer_id
    assert_equal "坂口 正則", trainer_page_2.trainer_name
    assert trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[13][:trainer]
    assert_equal "01157", trainer_page_2.trainer_id
    assert_equal "杉山 晴紀", trainer_page_2.trainer_name
    assert trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[14][:trainer]
    assert_equal "00438", trainer_page_2.trainer_id
    assert_equal "安田 隆行", trainer_page_2.trainer_name
    assert trainer_page_2.valid?
    assert trainer_page_2.exists?

    trainer_page_2 = entries_2[15][:trainer]
    assert_equal "01022", trainer_page_2.trainer_id
    assert_equal "石坂 正", trainer_page_2.trainer_name
    assert trainer_page_2.valid?
    assert trainer_page_2.exists?

    # execute - overwrite
    entries_2.each { |e| e[:trainer].save! }
  end

  it "download: invalid page" do
    # execute - new invalid page
    trainer_page = TrainerPage.new("99999")

    # check
    assert_equal "99999", trainer_page.trainer_id
    assert_nil trainer_page.trainer_name
    assert_not trainer_page.valid?
    assert_not trainer_page.exists?

    # execute - download
    trainer_page.download_from_web!

    # check
    assert_equal "99999", trainer_page.trainer_id
    assert_nil trainer_page.trainer_name
    assert_not trainer_page.valid?
    assert_not trainer_page.exists?

    # execute - save -> fail
    assert_raises "Invalid" do
      trainer_page.save!
    end

    # check
    assert_equal "99999", trainer_page.trainer_id
    assert_nil trainer_page.trainer_name
    assert_not trainer_page.valid?
    assert_not trainer_page.exists?
  end

  it "parse" do
    # setup
    trainer_page_html = File.open("test/fixtures/files/trainer.01120.html").read

    # execute - new and parse
    trainer_page = TrainerPage.new("01120", trainer_page_html)

    # check
    assert_equal "01120", trainer_page.trainer_id
    assert_equal "千田 輝彦", trainer_page.trainer_name
    assert trainer_page.valid?
    assert_not trainer_page.exists?
  end

  it "parse: invalid html" do
    # execute - new invalid html
    trainer_page = TrainerPage.new("00000", "Invalid html")

    # check
    assert_equal "00000", trainer_page.trainer_id
    assert_nil trainer_page.trainer_name
    assert_not trainer_page.valid?
    assert_not trainer_page.exists?
  end

  it "save, and overwrite" do
    # setup
    trainer_page_html = File.open("test/fixtures/files/trainer.01120.html").read

    # execute - インスタンス化 & パース
    trainer_page = TrainerPage.new("01120", trainer_page_html)

    # check
    assert_equal "01120", trainer_page.trainer_id
    assert_equal "千田 輝彦", trainer_page.trainer_name
    assert trainer_page.valid?
    assert_not trainer_page.exists?

    # execute - 保存
    trainer_page.save!

    # check
    assert trainer_page.valid?
    assert trainer_page.exists?

    # execute - Webから再ダウンロードする
    trainer_page.download_from_web!

    # check
    assert_equal "01120", trainer_page.trainer_id
    assert_equal "千田 輝彦", trainer_page.trainer_name
    assert trainer_page.valid?
    assert trainer_page.exists?

    # execute - 上書き保存
    trainer_page.save!

    # check
    assert_equal "01120", trainer_page.trainer_id
    assert_equal "千田 輝彦", trainer_page.trainer_name
    assert trainer_page.valid?
    assert trainer_page.exists?
  end

end
