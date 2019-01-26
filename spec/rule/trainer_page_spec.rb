RSpec.describe "trainer page spec" do

  before do
    @downloader = ScoringHorseRacing::SpecUtil.build_downloader

    @repo = ScoringHorseRacing::SpecUtil.build_resource_repository
    @repo.remove_s3_objects
  end

  it "download" do
    # setup
    entry_page_html = File.open("spec/data/entry.20180624.hanshin.1.html").read
    entry_page = ScoringHorseRacing::Rule::EntryPage.new("1809030801", entry_page_html, @downloader, @repo)

    # execute - new
    entries = entry_page.entries

    # check
    expect(entries.length).to eq 16

    trainer_page = entries[0][:trainer]
    expect(trainer_page.trainer_id).to eq "01120"
    expect(trainer_page.trainer_name).to be nil
    expect(trainer_page.valid?).to be_falsey
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[1][:trainer]
    expect(trainer_page.trainer_id).to eq "01022"
    expect(trainer_page.trainer_name).to be nil
    expect(trainer_page.valid?).to be_falsey
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[2][:trainer]
    expect(trainer_page.trainer_id).to eq "01046"
    expect(trainer_page.trainer_name).to be nil
    expect(trainer_page.valid?).to be_falsey
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[3][:trainer]
    expect(trainer_page.trainer_id).to eq "01140"
    expect(trainer_page.trainer_name).to be nil
    expect(trainer_page.valid?).to be_falsey
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[4][:trainer]
    expect(trainer_page.trainer_id).to eq "01041"
    expect(trainer_page.trainer_name).to be nil
    expect(trainer_page.valid?).to be_falsey
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[5][:trainer]
    expect(trainer_page.trainer_id).to eq "01073"
    expect(trainer_page.trainer_name).to be nil
    expect(trainer_page.valid?).to be_falsey
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[6][:trainer]
    expect(trainer_page.trainer_id).to eq "01078"
    expect(trainer_page.trainer_name).to be nil
    expect(trainer_page.valid?).to be_falsey
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[7][:trainer]
    expect(trainer_page.trainer_id).to eq "01104"
    expect(trainer_page.trainer_name).to be nil
    expect(trainer_page.valid?).to be_falsey
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[8][:trainer]
    expect(trainer_page.trainer_id).to eq "01050"
    expect(trainer_page.trainer_name).to be nil
    expect(trainer_page.valid?).to be_falsey
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[9][:trainer]
    expect(trainer_page.trainer_id).to eq "01138"
    expect(trainer_page.trainer_name).to be nil
    expect(trainer_page.valid?).to be_falsey
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[10][:trainer]
    expect(trainer_page.trainer_id).to eq "01066"
    expect(trainer_page.trainer_name).to be nil
    expect(trainer_page.valid?).to be_falsey
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[11][:trainer]
    expect(trainer_page.trainer_id).to eq "01111"
    expect(trainer_page.trainer_name).to be nil
    expect(trainer_page.valid?).to be_falsey
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[12][:trainer]
    expect(trainer_page.trainer_id).to eq "00356"
    expect(trainer_page.trainer_name).to be nil
    expect(trainer_page.valid?).to be_falsey
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[13][:trainer]
    expect(trainer_page.trainer_id).to eq "01157"
    expect(trainer_page.trainer_name).to be nil
    expect(trainer_page.valid?).to be_falsey
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[14][:trainer]
    expect(trainer_page.trainer_id).to eq "00438"
    expect(trainer_page.trainer_name).to be nil
    expect(trainer_page.valid?).to be_falsey
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[15][:trainer]
    expect(trainer_page.trainer_id).to eq "01022"
    expect(trainer_page.trainer_name).to be nil
    expect(trainer_page.valid?).to be_falsey
    expect(trainer_page.exists?).to be_falsey

    # execute - ダウンロード
    entries.each { |e| e[:trainer].download_from_web! }

    # check
    expect(entries.length).to eq 16

    trainer_page = entries[0][:trainer]
    expect(trainer_page.trainer_id).to eq "01120"
    expect(trainer_page.trainer_name).to eq "千田 輝彦"
    expect(trainer_page.valid?).to be_truthy
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[1][:trainer]
    expect(trainer_page.trainer_id).to eq "01022"
    expect(trainer_page.trainer_name).to eq "石坂 正"
    expect(trainer_page.valid?).to be_truthy
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[2][:trainer]
    expect(trainer_page.trainer_id).to eq "01046"
    expect(trainer_page.trainer_name).to eq "鮫島 一歩"
    expect(trainer_page.valid?).to be_truthy
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[3][:trainer]
    expect(trainer_page.trainer_id).to eq "01140"
    expect(trainer_page.trainer_name).to eq "石橋 守"
    expect(trainer_page.valid?).to be_truthy
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[4][:trainer]
    expect(trainer_page.trainer_id).to eq "01041"
    expect(trainer_page.trainer_name).to eq "藤沢 則雄"
    expect(trainer_page.valid?).to be_truthy
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[5][:trainer]
    expect(trainer_page.trainer_id).to eq "01073"
    expect(trainer_page.trainer_name).to eq "宮本 博"
    expect(trainer_page.valid?).to be_truthy
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[6][:trainer]
    expect(trainer_page.trainer_id).to eq "01078"
    expect(trainer_page.trainer_name).to eq "北出 成人"
    expect(trainer_page.valid?).to be_truthy
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[7][:trainer]
    expect(trainer_page.trainer_id).to eq "01104"
    expect(trainer_page.trainer_name).to eq "笹田 和秀"
    expect(trainer_page.valid?).to be_truthy
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[8][:trainer]
    expect(trainer_page.trainer_id).to eq "01050"
    expect(trainer_page.trainer_name).to eq "飯田 雄三"
    expect(trainer_page.valid?).to be_truthy
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[9][:trainer]
    expect(trainer_page.trainer_id).to eq "01138"
    expect(trainer_page.trainer_name).to eq "浜田 多実雄"
    expect(trainer_page.valid?).to be_truthy
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[10][:trainer]
    expect(trainer_page.trainer_id).to eq "01066"
    expect(trainer_page.trainer_name).to eq "岡田 稲男"
    expect(trainer_page.valid?).to be_truthy
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[11][:trainer]
    expect(trainer_page.trainer_id).to eq "01111"
    expect(trainer_page.trainer_name).to eq "鈴木 孝志"
    expect(trainer_page.valid?).to be_truthy
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[12][:trainer]
    expect(trainer_page.trainer_id).to eq "00356"
    expect(trainer_page.trainer_name).to eq "坂口 正則"
    expect(trainer_page.valid?).to be_truthy
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[13][:trainer]
    expect(trainer_page.trainer_id).to eq "01157"
    expect(trainer_page.trainer_name).to eq "杉山 晴紀"
    expect(trainer_page.valid?).to be_truthy
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[14][:trainer]
    expect(trainer_page.trainer_id).to eq "00438"
    expect(trainer_page.trainer_name).to eq "安田 隆行"
    expect(trainer_page.valid?).to be_truthy
    expect(trainer_page.exists?).to be_falsey

    trainer_page = entries[15][:trainer]
    expect(trainer_page.trainer_id).to eq "01022"
    expect(trainer_page.trainer_name).to eq "石坂 正"
    expect(trainer_page.valid?).to be_truthy
    expect(trainer_page.exists?).to be_falsey

    # execute - 保存
    entries.each { |e| e[:trainer].save! }

    # check
    entries.each do |e|
      expect(e[:trainer].valid?).to be_truthy
      expect(e[:trainer].exists?).to be_truthy
    end

    # execute - 再インスタンス化する
    entry_page = ScoringHorseRacing::Rule::EntryPage.new("1809030801", entry_page_html, @downloader, @repo)
    entries_2 = entry_page.entries

    # check
    expect(entries_2.length).to eq 16

    trainer_page_2 = entries_2[0][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01120"
    expect(trainer_page_2.trainer_name).to be nil
    expect(trainer_page_2.valid?).to be_falsey
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[1][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01022"
    expect(trainer_page_2.trainer_name).to be nil
    expect(trainer_page_2.valid?).to be_falsey
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[2][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01046"
    expect(trainer_page_2.trainer_name).to be nil
    expect(trainer_page_2.valid?).to be_falsey
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[3][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01140"
    expect(trainer_page_2.trainer_name).to be nil
    expect(trainer_page_2.valid?).to be_falsey
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[4][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01041"
    expect(trainer_page_2.trainer_name).to be nil
    expect(trainer_page_2.valid?).to be_falsey
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[5][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01073"
    expect(trainer_page_2.trainer_name).to be nil
    expect(trainer_page_2.valid?).to be_falsey
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[6][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01078"
    expect(trainer_page_2.trainer_name).to be nil
    expect(trainer_page_2.valid?).to be_falsey
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[7][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01104"
    expect(trainer_page_2.trainer_name).to be nil
    expect(trainer_page_2.valid?).to be_falsey
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[8][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01050"
    expect(trainer_page_2.trainer_name).to be nil
    expect(trainer_page_2.valid?).to be_falsey
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[9][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01138"
    expect(trainer_page_2.trainer_name).to be nil
    expect(trainer_page_2.valid?).to be_falsey
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[10][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01066"
    expect(trainer_page_2.trainer_name).to be nil
    expect(trainer_page_2.valid?).to be_falsey
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[11][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01111"
    expect(trainer_page_2.trainer_name).to be nil
    expect(trainer_page_2.valid?).to be_falsey
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[12][:trainer]
    expect(trainer_page_2.trainer_id).to eq "00356"
    expect(trainer_page_2.trainer_name).to be nil
    expect(trainer_page_2.valid?).to be_falsey
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[13][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01157"
    expect(trainer_page_2.trainer_name).to be nil
    expect(trainer_page_2.valid?).to be_falsey
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[14][:trainer]
    expect(trainer_page_2.trainer_id).to eq "00438"
    expect(trainer_page_2.trainer_name).to be nil
    expect(trainer_page_2.valid?).to be_falsey
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[15][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01022"
    expect(trainer_page_2.trainer_name).to be nil
    expect(trainer_page_2.valid?).to be_falsey
    expect(trainer_page_2.exists?).to be_truthy

    # execute - ダウンロード
    entries_2.each { |e| e[:trainer].download_from_s3! }

    # check
    expect(entries_2.length).to eq 16

    trainer_page_2 = entries_2[0][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01120"
    expect(trainer_page_2.trainer_name).to eq "千田 輝彦"
    expect(trainer_page_2.valid?).to be_truthy
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[1][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01022"
    expect(trainer_page_2.trainer_name).to eq "石坂 正"
    expect(trainer_page_2.valid?).to be_truthy
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[2][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01046"
    expect(trainer_page_2.trainer_name).to eq "鮫島 一歩"
    expect(trainer_page_2.valid?).to be_truthy
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[3][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01140"
    expect(trainer_page_2.trainer_name).to eq "石橋 守"
    expect(trainer_page_2.valid?).to be_truthy
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[4][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01041"
    expect(trainer_page_2.trainer_name).to eq "藤沢 則雄"
    expect(trainer_page_2.valid?).to be_truthy
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[5][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01073"
    expect(trainer_page_2.trainer_name).to eq "宮本 博"
    expect(trainer_page_2.valid?).to be_truthy
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[6][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01078"
    expect(trainer_page_2.trainer_name).to eq "北出 成人"
    expect(trainer_page_2.valid?).to be_truthy
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[7][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01104"
    expect(trainer_page_2.trainer_name).to eq "笹田 和秀"
    expect(trainer_page_2.valid?).to be_truthy
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[8][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01050"
    expect(trainer_page_2.trainer_name).to eq "飯田 雄三"
    expect(trainer_page_2.valid?).to be_truthy
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[9][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01138"
    expect(trainer_page_2.trainer_name).to eq "浜田 多実雄"
    expect(trainer_page_2.valid?).to be_truthy
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[10][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01066"
    expect(trainer_page_2.trainer_name).to eq "岡田 稲男"
    expect(trainer_page_2.valid?).to be_truthy
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[11][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01111"
    expect(trainer_page_2.trainer_name).to eq "鈴木 孝志"
    expect(trainer_page_2.valid?).to be_truthy
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[12][:trainer]
    expect(trainer_page_2.trainer_id).to eq "00356"
    expect(trainer_page_2.trainer_name).to eq "坂口 正則"
    expect(trainer_page_2.valid?).to be_truthy
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[13][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01157"
    expect(trainer_page_2.trainer_name).to eq "杉山 晴紀"
    expect(trainer_page_2.valid?).to be_truthy
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[14][:trainer]
    expect(trainer_page_2.trainer_id).to eq "00438"
    expect(trainer_page_2.trainer_name).to eq "安田 隆行"
    expect(trainer_page_2.valid?).to be_truthy
    expect(trainer_page_2.exists?).to be_truthy

    trainer_page_2 = entries_2[15][:trainer]
    expect(trainer_page_2.trainer_id).to eq "01022"
    expect(trainer_page_2.trainer_name).to eq "石坂 正"
    expect(trainer_page_2.valid?).to be_truthy
    expect(trainer_page_2.exists?).to be_truthy

    # execute - overwrite
    entries_2.each { |e| e[:trainer].save! }
  end

  it "download: invalid page" do
    # execute - new invalid page
    trainer_page = ScoringHorseRacing::Rule::TrainerPage.new("99999", nil, @downloader, @repo)

    # check
    expect(trainer_page.trainer_id).to eq "99999"
    expect(trainer_page.trainer_name).to be nil
    expect(trainer_page.valid?).to be_falsey
    expect(trainer_page.exists?).to be_falsey

    # execute - download
    trainer_page.download_from_web!

    # check
    expect(trainer_page.trainer_id).to eq "99999"
    expect(trainer_page.trainer_name).to be nil
    expect(trainer_page.valid?).to be_falsey
    expect(trainer_page.exists?).to be_falsey

    # execute - save -> fail
    expect { trainer_page.save! }.to raise_error "Invalid"

    # check
    expect(trainer_page.trainer_id).to eq "99999"
    expect(trainer_page.trainer_name).to be nil
    expect(trainer_page.valid?).to be_falsey
    expect(trainer_page.exists?).to be_falsey
  end

  it "parse" do
    # setup
    trainer_page_html = File.open("spec/data/trainer.01120.html").read

    # execute - new and parse
    trainer_page = ScoringHorseRacing::Rule::TrainerPage.new("01120", trainer_page_html, @downloader, @repo)

    # check
    expect(trainer_page.trainer_id).to eq "01120"
    expect(trainer_page.trainer_name).to eq "千田 輝彦"
    expect(trainer_page.valid?).to be_truthy
    expect(trainer_page.exists?).to be_falsey
  end

  it "parse: invalid html" do
    # execute - new invalid html
    trainer_page = ScoringHorseRacing::Rule::TrainerPage.new("00000", "Invalid html", @downloader, @repo)

    # check
    expect(trainer_page.trainer_id).to eq "00000"
    expect(trainer_page.trainer_name).to be nil
    expect(trainer_page.valid?).to be_falsey
    expect(trainer_page.exists?).to be_falsey
  end

  it "save, and overwrite" do
    # setup
    trainer_page_html = File.open("spec/data/trainer.01120.html").read

    # execute - インスタンス化 & パース
    trainer_page = ScoringHorseRacing::Rule::TrainerPage.new("01120", trainer_page_html, @downloader, @repo)

    # check
    expect(trainer_page.trainer_id).to eq "01120"
    expect(trainer_page.trainer_name).to eq "千田 輝彦"
    expect(trainer_page.valid?).to be_truthy
    expect(trainer_page.exists?).to be_falsey

    # execute - 保存
    trainer_page.save!

    # check
    expect(trainer_page.valid?).to be_truthy
    expect(trainer_page.exists?).to be_truthy

    # execute - Webから再ダウンロードする
    trainer_page.download_from_web!

    # check
    expect(trainer_page.trainer_id).to eq "01120"
    expect(trainer_page.trainer_name).to eq "千田 輝彦"
    expect(trainer_page.valid?).to be_truthy
    expect(trainer_page.exists?).to be_truthy

    # execute - 上書き保存
    trainer_page.save!

    # check
    expect(trainer_page.trainer_id).to eq "01120"
    expect(trainer_page.trainer_name).to eq "千田 輝彦"
    expect(trainer_page.valid?).to be_truthy
    expect(trainer_page.exists?).to be_truthy
  end

end
