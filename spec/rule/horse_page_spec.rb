RSpec.describe "horse page spec" do

  before do
    repo = ScoringHorseRacing::SpecUtil.build_resource_repository
    repo.remove_s3_objects
  end

  it "download" do
    # setup
    entry_page_html = File.open("spec/data/entry.20180624.hanshin.1.html").read
    entry_page = ScoringHorseRacing::Rule::EntryPage.new("1809030801", entry_page_html, @downloader, @repo)

    # execute - new
    entries = entry_page.entries

    # check
    assert_equal 16, entries.length

    horse_page = entries[0][:horse]
    assert_equal "2015104308", horse_page.horse_id
    assert_nil horse_page.horse_name
    assert_not horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[1][:horse]
    assert_equal "2015104964", horse_page.horse_id
    assert_nil horse_page.horse_name
    assert_not horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[2][:horse]
    assert_equal "2015100632", horse_page.horse_id
    assert_nil horse_page.horse_name
    assert_not horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[3][:horse]
    assert_equal "2015100586", horse_page.horse_id
    assert_nil horse_page.horse_name
    assert_not horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[4][:horse]
    assert_equal "2015103335", horse_page.horse_id
    assert_nil horse_page.horse_name
    assert_not horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[5][:horse]
    assert_equal "2015104928", horse_page.horse_id
    assert_nil horse_page.horse_name
    assert_not horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[6][:horse]
    assert_equal "2015106259", horse_page.horse_id
    assert_nil horse_page.horse_name
    assert_not horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[7][:horse]
    assert_equal "2015102694", horse_page.horse_id
    assert_nil horse_page.horse_name
    assert_not horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[8][:horse]
    assert_equal "2015102837", horse_page.horse_id
    assert_nil horse_page.horse_name
    assert_not horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[9][:horse]
    assert_equal "2015105363", horse_page.horse_id
    assert_nil horse_page.horse_name
    assert_not horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[10][:horse]
    assert_equal "2015101618", horse_page.horse_id
    assert_nil horse_page.horse_name
    assert_not horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[11][:horse]
    assert_equal "2015102853", horse_page.horse_id
    assert_nil horse_page.horse_name
    assert_not horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[12][:horse]
    assert_equal "2015103462", horse_page.horse_id
    assert_nil horse_page.horse_name
    assert_not horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[13][:horse]
    assert_equal "2015103590", horse_page.horse_id
    assert_nil horse_page.horse_name
    assert_not horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[14][:horse]
    assert_equal "2015104979", horse_page.horse_id
    assert_nil horse_page.horse_name
    assert_not horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[15][:horse]
    assert_equal "2015103557", horse_page.horse_id
    assert_nil horse_page.horse_name
    assert_not horse_page.valid?
    assert_not horse_page.exists?

    # execute - download
    entries.each { |e| e[:horse].download_from_web! }

    # check
    assert_equal 16, entries.length

    horse_page = entries[0][:horse]
    assert_equal "2015104308", horse_page.horse_id
    assert_equal "プロネルクール", horse_page.horse_name
    assert horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[1][:horse]
    assert_equal "2015104964", horse_page.horse_id
    assert_equal "スーブレット", horse_page.horse_name
    assert horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[2][:horse]
    assert_equal "2015100632", horse_page.horse_id
    assert_equal "アデル", horse_page.horse_name
    assert horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[3][:horse]
    assert_equal "2015100586", horse_page.horse_id
    assert_equal "ヤマニンフィオッコ", horse_page.horse_name
    assert horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[4][:horse]
    assert_equal "2015103335", horse_page.horse_id
    assert_equal "メイショウハニー", horse_page.horse_name
    assert horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[5][:horse]
    assert_equal "2015104928", horse_page.horse_id
    assert_equal "レンブランサ", horse_page.horse_name
    assert horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[6][:horse]
    assert_equal "2015106259", horse_page.horse_id
    assert_equal "アンジェレッタ", horse_page.horse_name
    assert horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[7][:horse]
    assert_equal "2015102694", horse_page.horse_id
    assert_equal "テーオーパートナー", horse_page.horse_name
    assert horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[8][:horse]
    assert_equal "2015102837", horse_page.horse_id
    assert_equal "ウインタイムリープ", horse_page.horse_name
    assert horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[9][:horse]
    assert_equal "2015105363", horse_page.horse_id
    assert_equal "モリノマリン", horse_page.horse_name
    assert horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[10][:horse]
    assert_equal "2015101618", horse_page.horse_id
    assert_equal "プロムクイーン", horse_page.horse_name
    assert horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[11][:horse]
    assert_equal "2015102853", horse_page.horse_id
    assert_equal "ナイスドゥ", horse_page.horse_name
    assert horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[12][:horse]
    assert_equal "2015103462", horse_page.horse_id
    assert_equal "アクアレーヌ", horse_page.horse_name
    assert horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[13][:horse]
    assert_equal "2015103590", horse_page.horse_id
    assert_equal "モンテルース", horse_page.horse_name
    assert horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[14][:horse]
    assert_equal "2015104979", horse_page.horse_id
    assert_equal "リーズン", horse_page.horse_name
    assert horse_page.valid?
    assert_not horse_page.exists?

    horse_page = entries[15][:horse]
    assert_equal "2015103557", horse_page.horse_id
    assert_equal "スマートスピカ", horse_page.horse_name
    assert horse_page.valid?
    assert_not horse_page.exists?

    # execute - save
    entries.each { |e| e[:horse].save! }

    # check
    entries.each do |e|
      assert e[:horse].valid?
      assert e[:horse].exists?
    end

    # execute - re-new
    entry_page = ScoringHorseRacing::Rule::EntryPage.new("1809030801", entry_page_html, @downloader, @repo)
    entries_2 = entry_page.entries

    # check
    assert_equal 16, entries_2.length

    horse_page_2 = entries_2[0][:horse]
    assert_equal "2015104308", horse_page_2.horse_id
    assert_nil horse_page_2.horse_name
    assert_not horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[1][:horse]
    assert_equal "2015104964", horse_page_2.horse_id
    assert_nil horse_page_2.horse_name
    assert_not horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[2][:horse]
    assert_equal "2015100632", horse_page_2.horse_id
    assert_nil horse_page_2.horse_name
    assert_not horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[3][:horse]
    assert_equal "2015100586", horse_page_2.horse_id
    assert_nil horse_page_2.horse_name
    assert_not horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[4][:horse]
    assert_equal "2015103335", horse_page_2.horse_id
    assert_nil horse_page_2.horse_name
    assert_not horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[5][:horse]
    assert_equal "2015104928", horse_page_2.horse_id
    assert_nil horse_page_2.horse_name
    assert_not horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[6][:horse]
    assert_equal "2015106259", horse_page_2.horse_id
    assert_nil horse_page_2.horse_name
    assert_not horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[7][:horse]
    assert_equal "2015102694", horse_page_2.horse_id
    assert_nil horse_page_2.horse_name
    assert_not horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[8][:horse]
    assert_equal "2015102837", horse_page_2.horse_id
    assert_nil horse_page_2.horse_name
    assert_not horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[9][:horse]
    assert_equal "2015105363", horse_page_2.horse_id
    assert_nil horse_page_2.horse_name
    assert_not horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[10][:horse]
    assert_equal "2015101618", horse_page_2.horse_id
    assert_nil horse_page_2.horse_name
    assert_not horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[11][:horse]
    assert_equal "2015102853", horse_page_2.horse_id
    assert_nil horse_page_2.horse_name
    assert_not horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[12][:horse]
    assert_equal "2015103462", horse_page_2.horse_id
    assert_nil horse_page_2.horse_name
    assert_not horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[13][:horse]
    assert_equal "2015103590", horse_page_2.horse_id
    assert_nil horse_page_2.horse_name
    assert_not horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[14][:horse]
    assert_equal "2015104979", horse_page_2.horse_id
    assert_nil horse_page_2.horse_name
    assert_not horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[15][:horse]
    assert_equal "2015103557", horse_page_2.horse_id
    assert_nil horse_page_2.horse_name
    assert_not horse_page_2.valid?
    assert horse_page_2.exists?

    # execute - download from s3
    entries_2.each { |e| e[:horse].download_from_s3! }

    # check
    assert_equal 16, entries_2.length

    horse_page_2 = entries_2[0][:horse]
    assert_equal "2015104308", horse_page_2.horse_id
    assert_equal "プロネルクール", horse_page_2.horse_name
    assert horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[1][:horse]
    assert_equal "2015104964", horse_page_2.horse_id
    assert_equal "スーブレット", horse_page_2.horse_name
    assert horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[2][:horse]
    assert_equal "2015100632", horse_page_2.horse_id
    assert_equal "アデル", horse_page_2.horse_name
    assert horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[3][:horse]
    assert_equal "2015100586", horse_page_2.horse_id
    assert_equal "ヤマニンフィオッコ", horse_page_2.horse_name
    assert horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[4][:horse]
    assert_equal "2015103335", horse_page_2.horse_id
    assert_equal "メイショウハニー", horse_page_2.horse_name
    assert horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[5][:horse]
    assert_equal "2015104928", horse_page_2.horse_id
    assert_equal "レンブランサ", horse_page_2.horse_name
    assert horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[6][:horse]
    assert_equal "2015106259", horse_page_2.horse_id
    assert_equal "アンジェレッタ", horse_page_2.horse_name
    assert horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[7][:horse]
    assert_equal "2015102694", horse_page_2.horse_id
    assert_equal "テーオーパートナー", horse_page_2.horse_name
    assert horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[8][:horse]
    assert_equal "2015102837", horse_page_2.horse_id
    assert_equal "ウインタイムリープ", horse_page_2.horse_name
    assert horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[9][:horse]
    assert_equal "2015105363", horse_page_2.horse_id
    assert_equal "モリノマリン", horse_page_2.horse_name
    assert horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[10][:horse]
    assert_equal "2015101618", horse_page_2.horse_id
    assert_equal "プロムクイーン", horse_page_2.horse_name
    assert horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[11][:horse]
    assert_equal "2015102853", horse_page_2.horse_id
    assert_equal "ナイスドゥ", horse_page_2.horse_name
    assert horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[12][:horse]
    assert_equal "2015103462", horse_page_2.horse_id
    assert_equal "アクアレーヌ", horse_page_2.horse_name
    assert horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[13][:horse]
    assert_equal "2015103590", horse_page_2.horse_id
    assert_equal "モンテルース", horse_page_2.horse_name
    assert horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[14][:horse]
    assert_equal "2015104979", horse_page_2.horse_id
    assert_equal "リーズン", horse_page_2.horse_name
    assert horse_page_2.valid?
    assert horse_page_2.exists?

    horse_page_2 = entries_2[15][:horse]
    assert_equal "2015103557", horse_page_2.horse_id
    assert_equal "スマートスピカ", horse_page_2.horse_name
    assert horse_page_2.valid?
    assert horse_page_2.exists?

    # execute - overwrite
    entries_2.each { |e| e[:horse].save! }
  end

  it "download: invalid page" do
    # execute - new invalid page
    horse_page = ScoringHorseRacing::Rule::HorsePage.new("0000000000", nil, @downloader, @repo)

    # check
    assert_equal "0000000000", horse_page.horse_id
    assert_nil horse_page.horse_name
    assert_not horse_page.valid?
    assert_not horse_page.exists?

    # execute - download -> fail
    horse_page.download_from_web!

    # check
    assert_equal "0000000000", horse_page.horse_id
    assert_nil horse_page.horse_name
    assert_not horse_page.valid?
    assert_not horse_page.exists?

    # execute - save -> fail
    assert_raises "Invalid" do
      horse_page.save!
    end

    # check
    assert_equal "0000000000", horse_page.horse_id
    assert_nil horse_page.horse_name
    assert_not horse_page.valid?
    assert_not horse_page.exists?
  end

  it "parse" do
    # setup
    horse_page_html = File.open("spec/data/horse.2015104308.html").read

    # execute - new and parse
    horse_page = ScoringHorseRacing::Rule::HorsePage.new("2015104308", horse_page_html, @downloader, @repo)

    # check
    assert_equal "2015104308", horse_page.horse_id
    assert_equal "プロネルクール", horse_page.horse_name
    assert horse_page.valid?
    assert_not horse_page.exists?
  end

  it "parse: invalid html" do
    # execute - new invalid html
    horse_page = ScoringHorseRacing::Rule::HorsePage.new("0000000000", "Invalid html", @downloader, @repo)

    # check
    assert_equal "0000000000", horse_page.horse_id
    assert_nil horse_page.horse_name
    assert_not horse_page.valid?
    assert_not horse_page.exists?
  end

  it "save, and overwrite" do
    # setup
    horse_page_html = File.open("spec/data/horse.2015104308.html").read

    # execute - new and parse
    horse_page = ScoringHorseRacing::Rule::HorsePage.new("2015104308", horse_page_html, @downloader, @repo)

    # check
    assert_equal "2015104308", horse_page.horse_id
    assert_equal "プロネルクール", horse_page.horse_name
    assert horse_page.valid?
    assert_not horse_page.exists?

    # save
    horse_page.save!

    # check
    assert horse_page.valid?
    assert horse_page.exists?

    # execute - re-download from web
    horse_page.download_from_web!

    # check
    assert horse_page.valid?
    assert horse_page.exists?

    # execute - save
    horse_page.save!

    # check
    assert horse_page.valid?
    assert horse_page.exists?
  end

end
