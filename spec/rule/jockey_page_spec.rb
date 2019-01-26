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
    expect(entries.length).to eq 16

    jockey_page = entries[0][:jockey]
    expect(jockey_page.jockey_id).to eq "05339"
    expect(jockey_page.jockey_name).to be nil
    expect(jockey_page.valid?).to be_falsey
    expect(jockey_page.exists?).to be_falsey

    jockey_page = entries[1][:jockey]
    expect(jockey_page.jockey_id).to eq "01014"
    expect(jockey_page.jockey_name).to be nil
    expect(jockey_page.valid?).to be_falsey
    expect(jockey_page.exists?).to be_falsey

    jockey_page = entries[2][:jockey]
    expect(jockey_page.jockey_id).to eq "01088"
    expect(jockey_page.jockey_name).to be nil
    expect(jockey_page.valid?).to be_falsey
    expect(jockey_page.exists?).to be_falsey

    jockey_page = entries[3][:jockey]
    expect(jockey_page.jockey_id).to eq "01114"
    expect(jockey_page.jockey_name).to be nil
    expect(jockey_page.valid?).to be_falsey
    expect(jockey_page.exists?).to be_falsey

    jockey_page = entries[4][:jockey]
    expect(jockey_page.jockey_id).to eq "01165"
    expect(jockey_page.jockey_name).to be nil
    expect(jockey_page.valid?).to be_falsey
    expect(jockey_page.exists?).to be_falsey

    jockey_page = entries[5][:jockey]
    expect(jockey_page.jockey_id).to eq "00894"
    expect(jockey_page.jockey_name).to be nil
    expect(jockey_page.valid?).to be_falsey
    expect(jockey_page.exists?).to be_falsey

    jockey_page = entries[6][:jockey]
    expect(jockey_page.jockey_id).to eq "01034"
    expect(jockey_page.jockey_name).to be nil
    expect(jockey_page.valid?).to be_falsey
    expect(jockey_page.exists?).to be_falsey

    jockey_page = entries[7][:jockey]
    expect(jockey_page.jockey_id).to eq "05203"
    expect(jockey_page.jockey_name).to be nil
    expect(jockey_page.valid?).to be_falsey
    expect(jockey_page.exists?).to be_falsey

    jockey_page = entries[8][:jockey]
    expect(jockey_page.jockey_id).to eq "01126"
    expect(jockey_page.jockey_name).to be nil
    expect(jockey_page.valid?).to be_falsey
    expect(jockey_page.exists?).to be_falsey

    jockey_page = entries[9][:jockey]
    expect(jockey_page.jockey_id).to eq "01019"
    expect(jockey_page.jockey_name).to be nil
    expect(jockey_page.valid?).to be_falsey
    expect(jockey_page.exists?).to be_falsey

    jockey_page = entries[10][:jockey]
    expect(jockey_page.jockey_id).to eq "01166"
    expect(jockey_page.jockey_name).to be nil
    expect(jockey_page.valid?).to be_falsey
    expect(jockey_page.exists?).to be_falsey

    jockey_page = entries[11][:jockey]
    expect(jockey_page.jockey_id).to eq "01018"
    expect(jockey_page.jockey_name).to be nil
    expect(jockey_page.valid?).to be_falsey
    expect(jockey_page.exists?).to be_falsey

    jockey_page = entries[12][:jockey]
    expect(jockey_page.jockey_id).to eq "01130"
    expect(jockey_page.jockey_name).to be nil
    expect(jockey_page.valid?).to be_falsey
    expect(jockey_page.exists?).to be_falsey

    jockey_page = entries[13][:jockey]
    expect(jockey_page.jockey_id).to eq "05386"
    expect(jockey_page.jockey_name).to be nil
    expect(jockey_page.valid?).to be_falsey
    expect(jockey_page.exists?).to be_falsey

    jockey_page = entries[14][:jockey]
    expect(jockey_page.jockey_id).to eq "01116"
    expect(jockey_page.jockey_name).to be nil
    expect(jockey_page.valid?).to be_falsey
    expect(jockey_page.exists?).to be_falsey

    jockey_page = entries[15][:jockey]
    expect(jockey_page.jockey_id).to eq "01154"
    expect(jockey_page.jockey_name).to be nil
    expect(jockey_page.valid?).to be_falsey
    expect(jockey_page.exists?).to be_falsey

    # execute - download
    entries.each { |e| e[:jockey].download_from_web! }

    # check
    expect(entries.length).to eq 16

    jockey_page = entries[0][:jockey]
    expect(jockey_page.jockey_id).to eq "05339"
    expect(jockey_page.jockey_name).to eq "C.ルメール"
    expect(jockey_page.valid?).to be_truthy
    expect(jockey_page.exists?).to be_falsey
    
    jockey_page = entries[1][:jockey]
    expect(jockey_page.jockey_id).to eq "01014"
    expect(jockey_page.jockey_name).to eq "福永 祐一"
    expect(jockey_page.valid?).to be_truthy
    expect(jockey_page.exists?).to be_falsey
    
    jockey_page = entries[2][:jockey]
    expect(jockey_page.jockey_id).to eq "01088"
    expect(jockey_page.jockey_name).to eq "川田 将雅"
    expect(jockey_page.valid?).to be_truthy
    expect(jockey_page.exists?).to be_falsey
    
    jockey_page = entries[3][:jockey]
    expect(jockey_page.jockey_id).to eq "01114"
    expect(jockey_page.jockey_name).to eq "田中 健"
    expect(jockey_page.valid?).to be_truthy
    expect(jockey_page.exists?).to be_falsey
    
    jockey_page = entries[4][:jockey]
    expect(jockey_page.jockey_id).to eq "01165"
    expect(jockey_page.jockey_name).to eq "森 裕太朗"
    expect(jockey_page.valid?).to be_truthy
    expect(jockey_page.exists?).to be_falsey
    
    jockey_page = entries[5][:jockey]
    expect(jockey_page.jockey_id).to eq "00894"
    expect(jockey_page.jockey_name).to eq "小牧 太"
    expect(jockey_page.valid?).to be_truthy
    expect(jockey_page.exists?).to be_falsey
    
    jockey_page = entries[6][:jockey]
    expect(jockey_page.jockey_id).to eq "01034"
    expect(jockey_page.jockey_name).to eq "酒井 学"
    expect(jockey_page.valid?).to be_truthy
    expect(jockey_page.exists?).to be_falsey
    
    jockey_page = entries[7][:jockey]
    expect(jockey_page.jockey_id).to eq "05203"
    expect(jockey_page.jockey_name).to eq "岩田 康誠"
    expect(jockey_page.valid?).to be_truthy
    expect(jockey_page.exists?).to be_falsey
    
    jockey_page = entries[8][:jockey]
    expect(jockey_page.jockey_id).to eq "01126"
    expect(jockey_page.jockey_name).to eq "松山 弘平"
    expect(jockey_page.valid?).to be_truthy
    expect(jockey_page.exists?).to be_falsey
    
    jockey_page = entries[9][:jockey]
    expect(jockey_page.jockey_id).to eq "01019"
    expect(jockey_page.jockey_name).to eq "秋山 真一郎"
    expect(jockey_page.valid?).to be_truthy
    expect(jockey_page.exists?).to be_falsey
    
    jockey_page = entries[10][:jockey]
    expect(jockey_page.jockey_id).to eq "01166"
    expect(jockey_page.jockey_name).to eq "川又 賢治"
    expect(jockey_page.valid?).to be_truthy
    expect(jockey_page.exists?).to be_falsey
    
    jockey_page = entries[11][:jockey]
    expect(jockey_page.jockey_id).to eq "01018"
    expect(jockey_page.jockey_name).to eq "和田 竜二"
    expect(jockey_page.valid?).to be_truthy
    expect(jockey_page.exists?).to be_falsey
    
    jockey_page = entries[12][:jockey]
    expect(jockey_page.jockey_id).to eq "01130"
    expect(jockey_page.jockey_name).to eq "高倉 稜"
    expect(jockey_page.valid?).to be_truthy
    expect(jockey_page.exists?).to be_falsey
    
    jockey_page = entries[13][:jockey]
    expect(jockey_page.jockey_id).to eq "05386"
    expect(jockey_page.jockey_name).to eq "戸崎 圭太"
    expect(jockey_page.valid?).to be_truthy
    expect(jockey_page.exists?).to be_falsey
    
    jockey_page = entries[14][:jockey]
    expect(jockey_page.jockey_id).to eq "01116"
    expect(jockey_page.jockey_name).to eq "藤岡 康太"
    expect(jockey_page.valid?).to be_truthy
    expect(jockey_page.exists?).to be_falsey
    
    jockey_page = entries[15][:jockey]
    expect(jockey_page.jockey_id).to eq "01154"
    expect(jockey_page.jockey_name).to eq "松若 風馬"
    expect(jockey_page.valid?).to be_truthy
    expect(jockey_page.exists?).to be_falsey

    # execute - save
    entries.each { |e| e[:jockey].save! }

    # check
    entries.each do |e|
      expect(e[:jockey].valid?).to be_truthy
      expect(e[:jockey].exists?).to be_truthy
    end

    # execute - re-new
    entry_page = ScoringHorseRacing::Rule::EntryPage.new("1809030801", entry_page_html, @downloader, @repo)
    entries_2 = entry_page.entries

    # check
    expect(entries_2.length).to eq 16

    jockey_page_2 = entries_2[0][:jockey]
    expect(jockey_page_2.jockey_id).to eq "05339"
    expect(jockey_page_2.jockey_name).to be nil
    expect(jockey_page_2.valid?).to be_falsey
    expect(jockey_page_2.exists?).to be_truthy

    jockey_page_2 = entries_2[1][:jockey]
    expect(jockey_page_2.jockey_id).to eq "01014"
    expect(jockey_page_2.jockey_name).to be nil
    expect(jockey_page_2.valid?).to be_falsey
    expect(jockey_page_2.exists?).to be_truthy

    jockey_page_2 = entries_2[2][:jockey]
    expect(jockey_page_2.jockey_id).to eq "01088"
    expect(jockey_page_2.jockey_name).to be nil
    expect(jockey_page_2.valid?).to be_falsey
    expect(jockey_page_2.exists?).to be_truthy

    jockey_page_2 = entries_2[3][:jockey]
    expect(jockey_page_2.jockey_id).to eq "01114"
    expect(jockey_page_2.jockey_name).to be nil
    expect(jockey_page_2.valid?).to be_falsey
    expect(jockey_page_2.exists?).to be_truthy

    jockey_page_2 = entries_2[4][:jockey]
    expect(jockey_page_2.jockey_id).to eq "01165"
    expect(jockey_page_2.jockey_name).to be nil
    expect(jockey_page_2.valid?).to be_falsey
    expect(jockey_page_2.exists?).to be_truthy

    jockey_page_2 = entries_2[5][:jockey]
    expect(jockey_page_2.jockey_id).to eq "00894"
    expect(jockey_page_2.jockey_name).to be nil
    expect(jockey_page_2.valid?).to be_falsey
    expect(jockey_page_2.exists?).to be_truthy

    jockey_page_2 = entries_2[6][:jockey]
    expect(jockey_page_2.jockey_id).to eq "01034"
    expect(jockey_page_2.jockey_name).to be nil
    expect(jockey_page_2.valid?).to be_falsey
    expect(jockey_page_2.exists?).to be_truthy

    jockey_page_2 = entries_2[7][:jockey]
    expect(jockey_page_2.jockey_id).to eq "05203"
    expect(jockey_page_2.jockey_name).to be nil
    expect(jockey_page_2.valid?).to be_falsey
    expect(jockey_page_2.exists?).to be_truthy

    jockey_page_2 = entries_2[8][:jockey]
    expect(jockey_page_2.jockey_id).to eq "01126"
    expect(jockey_page_2.jockey_name).to be nil
    expect(jockey_page_2.valid?).to be_falsey
    expect(jockey_page_2.exists?).to be_truthy

    jockey_page_2 = entries_2[9][:jockey]
    expect(jockey_page_2.jockey_id).to eq "01019"
    expect(jockey_page_2.jockey_name).to be nil
    expect(jockey_page_2.valid?).to be_falsey
    expect(jockey_page_2.exists?).to be_truthy

    jockey_page_2 = entries_2[10][:jockey]
    expect(jockey_page_2.jockey_id).to eq "01166"
    expect(jockey_page_2.jockey_name).to be nil
    expect(jockey_page_2.valid?).to be_falsey
    expect(jockey_page_2.exists?).to be_truthy

    jockey_page_2 = entries_2[11][:jockey]
    expect(jockey_page_2.jockey_id).to eq "01018"
    expect(jockey_page_2.jockey_name).to be nil
    expect(jockey_page_2.valid?).to be_falsey
    expect(jockey_page_2.exists?).to be_truthy

    jockey_page_2 = entries_2[12][:jockey]
    expect(jockey_page_2.jockey_id).to eq "01130"
    expect(jockey_page_2.jockey_name).to be nil
    expect(jockey_page_2.valid?).to be_falsey
    expect(jockey_page_2.exists?).to be_truthy

    jockey_page_2 = entries_2[13][:jockey]
    expect(jockey_page_2.jockey_id).to eq "05386"
    expect(jockey_page_2.jockey_name).to be nil
    expect(jockey_page_2.valid?).to be_falsey
    expect(jockey_page_2.exists?).to be_truthy

    jockey_page_2 = entries_2[14][:jockey]
    expect(jockey_page_2.jockey_id).to eq "01116"
    expect(jockey_page_2.jockey_name).to be nil
    expect(jockey_page_2.valid?).to be_falsey
    expect(jockey_page_2.exists?).to be_truthy

    jockey_page_2 = entries_2[15][:jockey]
    expect(jockey_page_2.jockey_id).to eq "01154"
    expect(jockey_page_2.jockey_name).to be nil
    expect(jockey_page_2.valid?).to be_falsey
    expect(jockey_page_2.exists?).to be_truthy

    # execute - download from s3
    entries_2.each { |e| e[:jockey].download_from_s3! }

    # check
    expect(entries_2.length).to eq 16

    jockey_page_2 = entries_2[0][:jockey]
    expect(jockey_page_2.jockey_id).to eq "05339"
    expect(jockey_page_2.jockey_name).to eq "C.ルメール"
    expect(jockey_page_2.valid?).to be_truthy
    expect(jockey_page_2.exists?).to be_truthy
    
    jockey_page_2 = entries_2[1][:jockey]
    expect(jockey_page_2.jockey_id).to eq "01014"
    expect(jockey_page_2.jockey_name).to eq "福永 祐一"
    expect(jockey_page_2.valid?).to be_truthy
    expect(jockey_page_2.exists?).to be_truthy
    
    jockey_page_2 = entries_2[2][:jockey]
    expect(jockey_page_2.jockey_id).to eq "01088"
    expect(jockey_page_2.jockey_name).to eq "川田 将雅"
    expect(jockey_page_2.valid?).to be_truthy
    expect(jockey_page_2.exists?).to be_truthy
    
    jockey_page_2 = entries_2[3][:jockey]
    expect(jockey_page_2.jockey_id).to eq "01114"
    expect(jockey_page_2.jockey_name).to eq "田中 健"
    expect(jockey_page_2.valid?).to be_truthy
    expect(jockey_page_2.exists?).to be_truthy
    
    jockey_page_2 = entries_2[4][:jockey]
    expect(jockey_page_2.jockey_id).to eq "01165"
    expect(jockey_page_2.jockey_name).to eq "森 裕太朗"
    expect(jockey_page_2.valid?).to be_truthy
    expect(jockey_page_2.exists?).to be_truthy
    
    jockey_page_2 = entries_2[5][:jockey]
    expect(jockey_page_2.jockey_id).to eq "00894"
    expect(jockey_page_2.jockey_name).to eq "小牧 太"
    expect(jockey_page_2.valid?).to be_truthy
    expect(jockey_page_2.exists?).to be_truthy
    
    jockey_page_2 = entries_2[6][:jockey]
    expect(jockey_page_2.jockey_id).to eq "01034"
    expect(jockey_page_2.jockey_name).to eq "酒井 学"
    expect(jockey_page_2.valid?).to be_truthy
    expect(jockey_page_2.exists?).to be_truthy
    
    jockey_page_2 = entries_2[7][:jockey]
    expect(jockey_page_2.jockey_id).to eq "05203"
    expect(jockey_page_2.jockey_name).to eq "岩田 康誠"
    expect(jockey_page_2.valid?).to be_truthy
    expect(jockey_page_2.exists?).to be_truthy
    
    jockey_page_2 = entries_2[8][:jockey]
    expect(jockey_page_2.jockey_id).to eq "01126"
    expect(jockey_page_2.jockey_name).to eq "松山 弘平"
    expect(jockey_page_2.valid?).to be_truthy
    expect(jockey_page_2.exists?).to be_truthy
    
    jockey_page_2 = entries_2[9][:jockey]
    expect(jockey_page_2.jockey_id).to eq "01019"
    expect(jockey_page_2.jockey_name).to eq "秋山 真一郎"
    expect(jockey_page_2.valid?).to be_truthy
    expect(jockey_page_2.exists?).to be_truthy
    
    jockey_page_2 = entries_2[10][:jockey]
    expect(jockey_page_2.jockey_id).to eq "01166"
    expect(jockey_page_2.jockey_name).to eq "川又 賢治"
    expect(jockey_page_2.valid?).to be_truthy
    expect(jockey_page_2.exists?).to be_truthy
    
    jockey_page_2 = entries_2[11][:jockey]
    expect(jockey_page_2.jockey_id).to eq "01018"
    expect(jockey_page_2.jockey_name).to eq "和田 竜二"
    expect(jockey_page_2.valid?).to be_truthy
    expect(jockey_page_2.exists?).to be_truthy
    
    jockey_page_2 = entries_2[12][:jockey]
    expect(jockey_page_2.jockey_id).to eq "01130"
    expect(jockey_page_2.jockey_name).to eq "高倉 稜"
    expect(jockey_page_2.valid?).to be_truthy
    expect(jockey_page_2.exists?).to be_truthy
    
    jockey_page_2 = entries_2[13][:jockey]
    expect(jockey_page_2.jockey_id).to eq "05386"
    expect(jockey_page_2.jockey_name).to eq "戸崎 圭太"
    expect(jockey_page_2.valid?).to be_truthy
    expect(jockey_page_2.exists?).to be_truthy
    
    jockey_page_2 = entries_2[14][:jockey]
    expect(jockey_page_2.jockey_id).to eq "01116"
    expect(jockey_page_2.jockey_name).to eq "藤岡 康太"
    expect(jockey_page_2.valid?).to be_truthy
    expect(jockey_page_2.exists?).to be_truthy
    
    jockey_page_2 = entries_2[15][:jockey]
    expect(jockey_page_2.jockey_id).to eq "01154"
    expect(jockey_page_2.jockey_name).to eq "松若 風馬"
    expect(jockey_page_2.valid?).to be_truthy
    expect(jockey_page_2.exists?).to be_truthy

    # execute - overwrite
    entries_2.each { |e| e[:jockey].save! }
  end

  it "download: invalid page" do
    # execute - new invalid page
    jockey_page = ScoringHorseRacing::Rule::JockeyPage.new("00000", nil, @downloader, @repo)

    # check
    expect(jockey_page.jockey_id).to eq "00000"
    expect(jockey_page.jockey_name).to be nil
    expect(jockey_page.valid?).to be_falsey
    expect(jockey_page.exists?).to be_falsey

    # execute - download
    jockey_page.download_from_web!

    # check
    expect(jockey_page.jockey_id).to eq "00000"
    expect(jockey_page.jockey_name).to be nil
    expect(jockey_page.valid?).to be_falsey
    expect(jockey_page.exists?).to be_falsey

    # execute - save -> fail
    expect { jockey_page.save! }.to raise_error "Invalid"

    # check
    expect(jockey_page.jockey_id).to eq "00000"
    expect(jockey_page.jockey_name).to be nil
    expect(jockey_page.valid?).to be_falsey
    expect(jockey_page.exists?).to be_falsey
  end

  it "parse" do
    # setup
    jockey_page_html = File.open("spec/data/jockey.05339.html").read

    # execute - new and parse
    jockey_page = ScoringHorseRacing::Rule::JockeyPage.new("05339", jockey_page_html, @downloader, @repo)

    # check
    expect(jockey_page.jockey_id).to eq "05339"
    expect(jockey_page.jockey_name).to eq "C.ルメール"
    expect(jockey_page.valid?).to be_truthy
    expect(jockey_page.exists?).to be_falsey
  end

  it "parse: invalid html" do
    # execute - new invalid html
    jockey_page = ScoringHorseRacing::Rule::JockeyPage.new("00000", "Invalid html", @downloader, @repo)

    # check
    expect(jockey_page.jockey_id).to eq "00000"
    expect(jockey_page.jockey_name).to be nil
    expect(jockey_page.valid?).to be_falsey
    expect(jockey_page.exists?).to be_falsey
  end

  it "save, and overwrite" do
    # setup
    jockey_page_html = File.open("spec/data/jockey.05339.html").read

    # execute - インスタンス化 & パース
    jockey_page = ScoringHorseRacing::Rule::JockeyPage.new("05339", jockey_page_html, @downloader, @repo)

    # check
    expect(jockey_page.jockey_id).to eq "05339"
    expect(jockey_page.jockey_name).to eq "C.ルメール"
    expect(jockey_page.valid?).to be_truthy
    expect(jockey_page.exists?).to be_falsey

    # execute - 保存
    jockey_page.save!

    # check
    expect(jockey_page.valid?).to be_truthy
    expect(jockey_page.exists?).to be_truthy

    # execute - Webから再ダウンロードする
    jockey_page.download_from_web!

    # check
    expect(jockey_page.jockey_id).to eq "05339"
    expect(jockey_page.jockey_name).to eq "C.ルメール"
    expect(jockey_page.valid?).to be_truthy
    expect(jockey_page.exists?).to be_truthy

    # execute - 上書き保存
    jockey_page.save!

    # check
    expect(jockey_page.jockey_id).to eq "05339"
    expect(jockey_page.jockey_name).to eq "C.ルメール"
    expect(jockey_page.valid?).to be_truthy
    expect(jockey_page.exists?).to be_truthy
  end

end
