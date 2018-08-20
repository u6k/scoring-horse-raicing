require 'test_helper'

class TrainerPageTest < ActiveSupport::TestCase

  def setup
    @bucket = NetModule.get_s3_bucket
    @bucket.objects.batch_delete!
  end

  test "download" do
    # setup
    entry_page_html = File.open("test/fixtures/files/entry.20180624.hanshin.1.html").read
    entry_page = EntryPage.new("1809030801", entry_page_html)

    # execute - new
    entries = entry_page.entries

    # check
    assert_equal 0, TrainerPage.find_all.length

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
    assert_equal 0, TrainerPage.find_all.length

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
    assert_equal 15, TrainerPage.find_all.length # 重複している調教師がいるため、16ではなく15

    entries.each do |e|
      assert e[:trainer].valid?
      assert e[:trainer].exists?
    end

    # execute - 再インスタンス化する
    entry_page = EntryPage.new("1809030801", entry_page_html)
    entries_2 = entry_page.entries

    # check
    assert_equal 15, TrainerPage.find_all.length

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
    assert_equal 15, TrainerPage.find_all.length

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

    # check
    assert_equal 15, TrainerPage.find_all.length
  end

  test "download: invalid page" do
    # execute - new invalid page
    trainer_page = TrainerPage.new("99999")

    # check
    assert_equal 0, TrainerPage.find_all.length

    assert_equal "99999", trainer_page.trainer_id
    assert_nil trainer_page.trainer_name
    assert_not trainer_page.valid?
    assert_not trainer_page.exists?

    # execute - download
    trainer_page.download_from_web!

    # check
    assert_equal 0, TrainerPage.find_all.length

    assert_equal "99999", trainer_page.trainer_id
    assert_nil trainer_page.trainer_name
    assert_not trainer_page.valid?
    assert_not trainer_page.exists?

    # execute - save -> fail
    assert_raises "Invalid" do
      trainer_page.save!
    end

    # check
    assert_equal 0, TrainerPage.find_all.length

    assert_equal "99999", trainer_page.trainer_id
    assert_nil trainer_page.trainer_name
    assert_not trainer_page.valid?
    assert_not trainer_page.exists?
  end

  test "parse" do
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

  test "parse: invalid html" do
    # execute - new invalid html
    trainer_page = TrainerPage.new("00000", "Invalid html")

    # check
    assert_equal "00000", trainer_page.trainer_id
    assert_nil trainer_page.trainer_name
    assert_not trainer_page.valid?
    assert_not trainer_page.exists?
  end

  test "save, and overwrite" do
    # setup
    trainer_page_html = File.open("test/fixtures/files/trainer.01120.html").read

    # execute - インスタンス化 & パース
    trainer_page = TrainerPage.new("01120", trainer_page_html)

    # check
    assert_equal 0, TrainerPage.find_all.length

    assert_equal "01120", trainer_page.trainer_id
    assert_equal "千田 輝彦", trainer_page.trainer_name
    assert trainer_page.valid?
    assert_not trainer_page.exists?

    # execute - 保存
    trainer_page.save!

    # check
    assert_equal 1, TrainerPage.find_all.length

    assert trainer_page.valid?
    assert trainer_page.exists?

    # execute - Webから再ダウンロードする
    trainer_page.download_from_web!

    # check
    assert_equal 1, TrainerPage.find_all.length

    assert_equal "01120", trainer_page.trainer_id
    assert_equal "千田 輝彦", trainer_page.trainer_name
    assert trainer_page.valid?
    assert trainer_page.exists?

    # execute - 上書き保存
    trainer_page.save!

    # check
    assert_equal 1, TrainerPage.find_all.length

    assert_equal "01120", trainer_page.trainer_id
    assert_equal "千田 輝彦", trainer_page.trainer_name
    assert trainer_page.valid?
    assert trainer_page.exists?
  end

  test "find" do
    # setup
    trainer_pages = []
    trainer_pages << TrainerPage.new("01120", File.open("test/fixtures/files/trainer.01120.html").read)
    trainer_pages << TrainerPage.new("01022", File.open("test/fixtures/files/trainer.01022.html").read)
    trainer_pages << TrainerPage.new("01046", File.open("test/fixtures/files/trainer.01046.html").read)
    trainer_pages << TrainerPage.new("01140", File.open("test/fixtures/files/trainer.01140.html").read)
    trainer_pages << TrainerPage.new("01041", File.open("test/fixtures/files/trainer.01041.html").read)
    trainer_pages << TrainerPage.new("01073", File.open("test/fixtures/files/trainer.01073.html").read)
    trainer_pages << TrainerPage.new("01078", File.open("test/fixtures/files/trainer.01078.html").read)
    trainer_pages << TrainerPage.new("01104", File.open("test/fixtures/files/trainer.01104.html").read)
    trainer_pages << TrainerPage.new("01050", File.open("test/fixtures/files/trainer.01050.html").read)
    trainer_pages << TrainerPage.new("01138", File.open("test/fixtures/files/trainer.01138.html").read)
    trainer_pages << TrainerPage.new("01066", File.open("test/fixtures/files/trainer.01066.html").read)
    trainer_pages << TrainerPage.new("01111", File.open("test/fixtures/files/trainer.01111.html").read)
    trainer_pages << TrainerPage.new("00356", File.open("test/fixtures/files/trainer.00356.html").read)
    trainer_pages << TrainerPage.new("01157", File.open("test/fixtures/files/trainer.01157.html").read)
    trainer_pages << TrainerPage.new("00438", File.open("test/fixtures/files/trainer.00438.html").read)

    # check - 未保存時は0件
    assert_equal 0, TrainerPage.find_all.length

    # execute - 保存してから検索
    trainer_pages.each { |t| t.save! }

    trainer_pages_2 = TrainerPage.find_all

    trainer_pages_2.each { |t| t.download_from_s3! }

    # check
    assert_equal 15, trainer_pages_2.length

    trainer_pages_2.each do |trainer_page_2|
      trainer_page = trainer_pages.find { |j| j.trainer_id == trainer_page_2.trainer_id }

      assert trainer_page_2.same?(trainer_page)
    end
  end

end
