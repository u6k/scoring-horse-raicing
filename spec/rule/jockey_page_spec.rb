RSpec.describe "jockey page spec" do

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

    jockey_page = entries[0][:jockey]
    assert_equal "05339", jockey_page.jockey_id
    assert_nil jockey_page.jockey_name
    assert_not jockey_page.valid?
    assert_not jockey_page.exists?

    jockey_page = entries[1][:jockey]
    assert_equal "01014", jockey_page.jockey_id
    assert_nil jockey_page.jockey_name
    assert_not jockey_page.valid?
    assert_not jockey_page.exists?

    jockey_page = entries[2][:jockey]
    assert_equal "01088", jockey_page.jockey_id
    assert_nil jockey_page.jockey_name
    assert_not jockey_page.valid?
    assert_not jockey_page.exists?

    jockey_page = entries[3][:jockey]
    assert_equal "01114", jockey_page.jockey_id
    assert_nil jockey_page.jockey_name
    assert_not jockey_page.valid?
    assert_not jockey_page.exists?

    jockey_page = entries[4][:jockey]
    assert_equal "01165", jockey_page.jockey_id
    assert_nil jockey_page.jockey_name
    assert_not jockey_page.valid?
    assert_not jockey_page.exists?

    jockey_page = entries[5][:jockey]
    assert_equal "00894", jockey_page.jockey_id
    assert_nil jockey_page.jockey_name
    assert_not jockey_page.valid?
    assert_not jockey_page.exists?

    jockey_page = entries[6][:jockey]
    assert_equal "01034", jockey_page.jockey_id
    assert_nil jockey_page.jockey_name
    assert_not jockey_page.valid?
    assert_not jockey_page.exists?

    jockey_page = entries[7][:jockey]
    assert_equal "05203", jockey_page.jockey_id
    assert_nil jockey_page.jockey_name
    assert_not jockey_page.valid?
    assert_not jockey_page.exists?

    jockey_page = entries[8][:jockey]
    assert_equal "01126", jockey_page.jockey_id
    assert_nil jockey_page.jockey_name
    assert_not jockey_page.valid?
    assert_not jockey_page.exists?

    jockey_page = entries[9][:jockey]
    assert_equal "01019", jockey_page.jockey_id
    assert_nil jockey_page.jockey_name
    assert_not jockey_page.valid?
    assert_not jockey_page.exists?

    jockey_page = entries[10][:jockey]
    assert_equal "01166", jockey_page.jockey_id
    assert_nil jockey_page.jockey_name
    assert_not jockey_page.valid?
    assert_not jockey_page.exists?

    jockey_page = entries[11][:jockey]
    assert_equal "01018", jockey_page.jockey_id
    assert_nil jockey_page.jockey_name
    assert_not jockey_page.valid?
    assert_not jockey_page.exists?

    jockey_page = entries[12][:jockey]
    assert_equal "01130", jockey_page.jockey_id
    assert_nil jockey_page.jockey_name
    assert_not jockey_page.valid?
    assert_not jockey_page.exists?

    jockey_page = entries[13][:jockey]
    assert_equal "05386", jockey_page.jockey_id
    assert_nil jockey_page.jockey_name
    assert_not jockey_page.valid?
    assert_not jockey_page.exists?

    jockey_page = entries[14][:jockey]
    assert_equal "01116", jockey_page.jockey_id
    assert_nil jockey_page.jockey_name
    assert_not jockey_page.valid?
    assert_not jockey_page.exists?

    jockey_page = entries[15][:jockey]
    assert_equal "01154", jockey_page.jockey_id
    assert_nil jockey_page.jockey_name
    assert_not jockey_page.valid?
    assert_not jockey_page.exists?

    # execute - download
    entries.each { |e| e[:jockey].download_from_web! }

    # check
    assert_equal 16, entries.length

    jockey_page = entries[0][:jockey]
    assert_equal "05339", jockey_page.jockey_id
    assert_equal "C.ルメール", jockey_page.jockey_name
    assert jockey_page.valid?
    assert_not jockey_page.exists?
    
    jockey_page = entries[1][:jockey]
    assert_equal "01014", jockey_page.jockey_id
    assert_equal "福永 祐一", jockey_page.jockey_name
    assert jockey_page.valid?
    assert_not jockey_page.exists?
    
    jockey_page = entries[2][:jockey]
    assert_equal "01088", jockey_page.jockey_id
    assert_equal "川田 将雅", jockey_page.jockey_name
    assert jockey_page.valid?
    assert_not jockey_page.exists?
    
    jockey_page = entries[3][:jockey]
    assert_equal "01114", jockey_page.jockey_id
    assert_equal "田中 健", jockey_page.jockey_name
    assert jockey_page.valid?
    assert_not jockey_page.exists?
    
    jockey_page = entries[4][:jockey]
    assert_equal "01165", jockey_page.jockey_id
    assert_equal "森 裕太朗", jockey_page.jockey_name
    assert jockey_page.valid?
    assert_not jockey_page.exists?
    
    jockey_page = entries[5][:jockey]
    assert_equal "00894", jockey_page.jockey_id
    assert_equal "小牧 太", jockey_page.jockey_name
    assert jockey_page.valid?
    assert_not jockey_page.exists?
    
    jockey_page = entries[6][:jockey]
    assert_equal "01034", jockey_page.jockey_id
    assert_equal "酒井 学", jockey_page.jockey_name
    assert jockey_page.valid?
    assert_not jockey_page.exists?
    
    jockey_page = entries[7][:jockey]
    assert_equal "05203", jockey_page.jockey_id
    assert_equal "岩田 康誠", jockey_page.jockey_name
    assert jockey_page.valid?
    assert_not jockey_page.exists?
    
    jockey_page = entries[8][:jockey]
    assert_equal "01126", jockey_page.jockey_id
    assert_equal "松山 弘平", jockey_page.jockey_name
    assert jockey_page.valid?
    assert_not jockey_page.exists?
    
    jockey_page = entries[9][:jockey]
    assert_equal "01019", jockey_page.jockey_id
    assert_equal "秋山 真一郎", jockey_page.jockey_name
    assert jockey_page.valid?
    assert_not jockey_page.exists?
    
    jockey_page = entries[10][:jockey]
    assert_equal "01166", jockey_page.jockey_id
    assert_equal "川又 賢治", jockey_page.jockey_name
    assert jockey_page.valid?
    assert_not jockey_page.exists?
    
    jockey_page = entries[11][:jockey]
    assert_equal "01018", jockey_page.jockey_id
    assert_equal "和田 竜二", jockey_page.jockey_name
    assert jockey_page.valid?
    assert_not jockey_page.exists?
    
    jockey_page = entries[12][:jockey]
    assert_equal "01130", jockey_page.jockey_id
    assert_equal "高倉 稜", jockey_page.jockey_name
    assert jockey_page.valid?
    assert_not jockey_page.exists?
    
    jockey_page = entries[13][:jockey]
    assert_equal "05386", jockey_page.jockey_id
    assert_equal "戸崎 圭太", jockey_page.jockey_name
    assert jockey_page.valid?
    assert_not jockey_page.exists?
    
    jockey_page = entries[14][:jockey]
    assert_equal "01116", jockey_page.jockey_id
    assert_equal "藤岡 康太", jockey_page.jockey_name
    assert jockey_page.valid?
    assert_not jockey_page.exists?
    
    jockey_page = entries[15][:jockey]
    assert_equal "01154", jockey_page.jockey_id
    assert_equal "松若 風馬", jockey_page.jockey_name
    assert jockey_page.valid?
    assert_not jockey_page.exists?

    # execute - save
    entries.each { |e| e[:jockey].save! }

    # check
    entries.each do |e|
      assert e[:jockey].valid?
      assert e[:jockey].exists?
    end

    # execute - re-new
    entry_page = ScoringHorseRacing::Rule::EntryPage.new("1809030801", entry_page_html, @downloader, @repo)
    entries_2 = entry_page.entries

    # check
    assert_equal 16, entries_2.length

    jockey_page_2 = entries_2[0][:jockey]
    assert_equal "05339", jockey_page_2.jockey_id
    assert_nil jockey_page_2.jockey_name
    assert_not jockey_page_2.valid?
    assert jockey_page_2.exists?

    jockey_page_2 = entries_2[1][:jockey]
    assert_equal "01014", jockey_page_2.jockey_id
    assert_nil jockey_page_2.jockey_name
    assert_not jockey_page_2.valid?
    assert jockey_page_2.exists?

    jockey_page_2 = entries_2[2][:jockey]
    assert_equal "01088", jockey_page_2.jockey_id
    assert_nil jockey_page_2.jockey_name
    assert_not jockey_page_2.valid?
    assert jockey_page_2.exists?

    jockey_page_2 = entries_2[3][:jockey]
    assert_equal "01114", jockey_page_2.jockey_id
    assert_nil jockey_page_2.jockey_name
    assert_not jockey_page_2.valid?
    assert jockey_page_2.exists?

    jockey_page_2 = entries_2[4][:jockey]
    assert_equal "01165", jockey_page_2.jockey_id
    assert_nil jockey_page_2.jockey_name
    assert_not jockey_page_2.valid?
    assert jockey_page_2.exists?

    jockey_page_2 = entries_2[5][:jockey]
    assert_equal "00894", jockey_page_2.jockey_id
    assert_nil jockey_page_2.jockey_name
    assert_not jockey_page_2.valid?
    assert jockey_page_2.exists?

    jockey_page_2 = entries_2[6][:jockey]
    assert_equal "01034", jockey_page_2.jockey_id
    assert_nil jockey_page_2.jockey_name
    assert_not jockey_page_2.valid?
    assert jockey_page_2.exists?

    jockey_page_2 = entries_2[7][:jockey]
    assert_equal "05203", jockey_page_2.jockey_id
    assert_nil jockey_page_2.jockey_name
    assert_not jockey_page_2.valid?
    assert jockey_page_2.exists?

    jockey_page_2 = entries_2[8][:jockey]
    assert_equal "01126", jockey_page_2.jockey_id
    assert_nil jockey_page_2.jockey_name
    assert_not jockey_page_2.valid?
    assert jockey_page_2.exists?

    jockey_page_2 = entries_2[9][:jockey]
    assert_equal "01019", jockey_page_2.jockey_id
    assert_nil jockey_page_2.jockey_name
    assert_not jockey_page_2.valid?
    assert jockey_page_2.exists?

    jockey_page_2 = entries_2[10][:jockey]
    assert_equal "01166", jockey_page_2.jockey_id
    assert_nil jockey_page_2.jockey_name
    assert_not jockey_page_2.valid?
    assert jockey_page_2.exists?

    jockey_page_2 = entries_2[11][:jockey]
    assert_equal "01018", jockey_page_2.jockey_id
    assert_nil jockey_page_2.jockey_name
    assert_not jockey_page_2.valid?
    assert jockey_page_2.exists?

    jockey_page_2 = entries_2[12][:jockey]
    assert_equal "01130", jockey_page_2.jockey_id
    assert_nil jockey_page_2.jockey_name
    assert_not jockey_page_2.valid?
    assert jockey_page_2.exists?

    jockey_page_2 = entries_2[13][:jockey]
    assert_equal "05386", jockey_page_2.jockey_id
    assert_nil jockey_page_2.jockey_name
    assert_not jockey_page_2.valid?
    assert jockey_page_2.exists?

    jockey_page_2 = entries_2[14][:jockey]
    assert_equal "01116", jockey_page_2.jockey_id
    assert_nil jockey_page_2.jockey_name
    assert_not jockey_page_2.valid?
    assert jockey_page_2.exists?

    jockey_page_2 = entries_2[15][:jockey]
    assert_equal "01154", jockey_page_2.jockey_id
    assert_nil jockey_page_2.jockey_name
    assert_not jockey_page_2.valid?
    assert jockey_page_2.exists?

    # execute - download from s3
    entries_2.each { |e| e[:jockey].download_from_s3! }

    # check
    assert_equal 16, entries_2.length

    jockey_page_2 = entries_2[0][:jockey]
    assert_equal "05339", jockey_page_2.jockey_id
    assert_equal "C.ルメール", jockey_page_2.jockey_name
    assert jockey_page_2.valid?
    assert jockey_page_2.exists?
    
    jockey_page_2 = entries_2[1][:jockey]
    assert_equal "01014", jockey_page_2.jockey_id
    assert_equal "福永 祐一", jockey_page_2.jockey_name
    assert jockey_page_2.valid?
    assert jockey_page_2.exists?
    
    jockey_page_2 = entries_2[2][:jockey]
    assert_equal "01088", jockey_page_2.jockey_id
    assert_equal "川田 将雅", jockey_page_2.jockey_name
    assert jockey_page_2.valid?
    assert jockey_page_2.exists?
    
    jockey_page_2 = entries_2[3][:jockey]
    assert_equal "01114", jockey_page_2.jockey_id
    assert_equal "田中 健", jockey_page_2.jockey_name
    assert jockey_page_2.valid?
    assert jockey_page_2.exists?
    
    jockey_page_2 = entries_2[4][:jockey]
    assert_equal "01165", jockey_page_2.jockey_id
    assert_equal "森 裕太朗", jockey_page_2.jockey_name
    assert jockey_page_2.valid?
    assert jockey_page_2.exists?
    
    jockey_page_2 = entries_2[5][:jockey]
    assert_equal "00894", jockey_page_2.jockey_id
    assert_equal "小牧 太", jockey_page_2.jockey_name
    assert jockey_page_2.valid?
    assert jockey_page_2.exists?
    
    jockey_page_2 = entries_2[6][:jockey]
    assert_equal "01034", jockey_page_2.jockey_id
    assert_equal "酒井 学", jockey_page_2.jockey_name
    assert jockey_page_2.valid?
    assert jockey_page_2.exists?
    
    jockey_page_2 = entries_2[7][:jockey]
    assert_equal "05203", jockey_page_2.jockey_id
    assert_equal "岩田 康誠", jockey_page_2.jockey_name
    assert jockey_page_2.valid?
    assert jockey_page_2.exists?
    
    jockey_page_2 = entries_2[8][:jockey]
    assert_equal "01126", jockey_page_2.jockey_id
    assert_equal "松山 弘平", jockey_page_2.jockey_name
    assert jockey_page_2.valid?
    assert jockey_page_2.exists?
    
    jockey_page_2 = entries_2[9][:jockey]
    assert_equal "01019", jockey_page_2.jockey_id
    assert_equal "秋山 真一郎", jockey_page_2.jockey_name
    assert jockey_page_2.valid?
    assert jockey_page_2.exists?
    
    jockey_page_2 = entries_2[10][:jockey]
    assert_equal "01166", jockey_page_2.jockey_id
    assert_equal "川又 賢治", jockey_page_2.jockey_name
    assert jockey_page_2.valid?
    assert jockey_page_2.exists?
    
    jockey_page_2 = entries_2[11][:jockey]
    assert_equal "01018", jockey_page_2.jockey_id
    assert_equal "和田 竜二", jockey_page_2.jockey_name
    assert jockey_page_2.valid?
    assert jockey_page_2.exists?
    
    jockey_page_2 = entries_2[12][:jockey]
    assert_equal "01130", jockey_page_2.jockey_id
    assert_equal "高倉 稜", jockey_page_2.jockey_name
    assert jockey_page_2.valid?
    assert jockey_page_2.exists?
    
    jockey_page_2 = entries_2[13][:jockey]
    assert_equal "05386", jockey_page_2.jockey_id
    assert_equal "戸崎 圭太", jockey_page_2.jockey_name
    assert jockey_page_2.valid?
    assert jockey_page_2.exists?
    
    jockey_page_2 = entries_2[14][:jockey]
    assert_equal "01116", jockey_page_2.jockey_id
    assert_equal "藤岡 康太", jockey_page_2.jockey_name
    assert jockey_page_2.valid?
    assert jockey_page_2.exists?
    
    jockey_page_2 = entries_2[15][:jockey]
    assert_equal "01154", jockey_page_2.jockey_id
    assert_equal "松若 風馬", jockey_page_2.jockey_name
    assert jockey_page_2.valid?
    assert jockey_page_2.exists?

    # execute - overwrite
    entries_2.each { |e| e[:jockey].save! }
  end

  it "download: invalid page" do
    # execute - new invalid page
    jockey_page = ScoringHorseRacing::Rule::JockeyPage.new("00000", nil, @downloader, @repo)

    # check
    assert_equal "00000", jockey_page.jockey_id
    assert_nil jockey_page.jockey_name
    assert_not jockey_page.valid?
    assert_not jockey_page.exists?

    # execute - download
    jockey_page.download_from_web!

    # check
    assert_equal "00000", jockey_page.jockey_id
    assert_nil jockey_page.jockey_name
    assert_not jockey_page.valid?
    assert_not jockey_page.exists?

    # execute - save -> fail
    assert_raises "Invalid" do
      jockey_page.save!
    end

    # check
    assert_equal "00000", jockey_page.jockey_id
    assert_nil jockey_page.jockey_name
    assert_not jockey_page.valid?
    assert_not jockey_page.exists?
  end

  it "parse" do
    # setup
    jockey_page_html = File.open("spec/data/jockey.05339.html").read

    # execute - new and parse
    jockey_page = ScoringHorseRacing::Rule::JockeyPage.new("05339", jockey_page_html, @downloader, @repo)

    # check
    assert_equal "05339", jockey_page.jockey_id
    assert_equal "C.ルメール", jockey_page.jockey_name
    assert jockey_page.valid?
    assert_not jockey_page.exists?
  end

  it "parse: invalid html" do
    # execute - new invalid html
    jockey_page = ScoringHorseRacing::Rule::JockeyPage.new("00000", "Invalid html", @downloader, @repo)

    # check
    assert_equal "00000", jockey_page.jockey_id
    assert_nil jockey_page.jockey_name
    assert_not jockey_page.valid?
    assert_not jockey_page.exists?
  end

  it "save, and overwrite" do
    # setup
    jockey_page_html = File.open("spec/data/jockey.05339.html").read

    # execute - インスタンス化 & パース
    jockey_page = ScoringHorseRacing::Rule::JockeyPage.new("05339", jockey_page_html, @downloader, @repo)

    # check
    assert_equal "05339", jockey_page.jockey_id
    assert_equal "C.ルメール", jockey_page.jockey_name
    assert jockey_page.valid?
    assert_not jockey_page.exists?

    # execute - 保存
    jockey_page.save!

    # check
    assert jockey_page.valid?
    assert jockey_page.exists?

    # execute - Webから再ダウンロードする
    jockey_page.download_from_web!

    # check
    assert_equal "05339", jockey_page.jockey_id
    assert_equal "C.ルメール", jockey_page.jockey_name
    assert jockey_page.valid?
    assert jockey_page.exists?

    # execute - 上書き保存
    jockey_page.save!

    # check
    assert_equal "05339", jockey_page.jockey_id
    assert_equal "C.ルメール", jockey_page.jockey_name
    assert jockey_page.valid?
    assert jockey_page.exists?
  end

end
