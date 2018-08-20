require 'test_helper'

class JockeyPageTest < ActiveSupport::TestCase

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
    assert_equal 0, HorsePage.find_all.length

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
    assert_equal 0, JockeyPage.find_all.length

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
    assert_equal 16, JockeyPage.find_all.length

    entries.each do |e|
      assert e[:jockey].valid?
      assert e[:jockey].exists?
    end

    # execute - re-new
    entry_page = EntryPage.new("1809030801", entry_page_html)
    entries_2 = entry_page.entries

    # check
    assert_equal 16, JockeyPage.find_all.length

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
    assert_equal 16, JockeyPage.find_all.length

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

    # check
    assert_equal 16, JockeyPage.find_all.length
  end

  test "download: invalid page" do
    # execute - new invalid page
    jockey_page = JockeyPage.new("00000")

    # check
    assert_equal 0, JockeyPage.find_all.length

    assert_equal "00000", jockey_page.jockey_id
    assert_nil jockey_page.jockey_name
    assert_not jockey_page.valid?
    assert_not jockey_page.exists?

    # execute - download
    jockey_page.download_from_web!

    # check
    assert_equal 0, JockeyPage.find_all.length

    assert_equal "00000", jockey_page.jockey_id
    assert_nil jockey_page.jockey_name
    assert_not jockey_page.valid?
    assert_not jockey_page.exists?

    # execute - save -> fail
    assert_raises "Invalid" do
      jockey_page.save!
    end

    # check
    assert_equal 0, JockeyPage.find_all.length

    assert_equal "00000", jockey_page.jockey_id
    assert_nil jockey_page.jockey_name
    assert_not jockey_page.valid?
    assert_not jockey_page.exists?
  end

  test "parse" do
    # setup
    jockey_page_html = File.open("test/fixtures/files/jockey.05339.html").read

    # execute - new and parse
    jockey_page = JockeyPage.new("05339", jockey_page_html)

    # check
    assert_equal "05339", jockey_page.jockey_id
    assert_equal "C.ルメール", jockey_page.jockey_name
    assert jockey_page.valid?
    assert_not jockey_page.exists?
  end

  test "parse: invalid html" do
    # execute - new invalid html
    jockey_page = JockeyPage.new("00000", "Invalid html")

    # check
    assert_equal "00000", jockey_page.jockey_id
    assert_nil jockey_page.jockey_name
    assert_not jockey_page.valid?
    assert_not jockey_page.exists?
  end

  test "save, and overwrite" do
    # setup
    jockey_page_html = File.open("test/fixtures/files/jockey.05339.html").read

    # execute - インスタンス化 & パース
    jockey_page = JockeyPage.new("05339", jockey_page_html)

    # check
    assert_equal 0, JockeyPage.find_all.length

    assert_equal "05339", jockey_page.jockey_id
    assert_equal "C.ルメール", jockey_page.jockey_name
    assert jockey_page.valid?
    assert_not jockey_page.exists?

    # execute - 保存
    jockey_page.save!

    # check
    assert_equal 1, JockeyPage.find_all.length

    assert jockey_page.valid?
    assert jockey_page.exists?

    # execute - Webから再ダウンロードする
    jockey_page.download_from_web!

    # check
    assert_equal 1, JockeyPage.find_all.length

    assert_equal "05339", jockey_page.jockey_id
    assert_equal "C.ルメール", jockey_page.jockey_name
    assert jockey_page.valid?
    assert jockey_page.exists?

    # execute - 上書き保存
    jockey_page.save!

    # check
    assert_equal 1, JockeyPage.find_all.length

    assert_equal "05339", jockey_page.jockey_id
    assert_equal "C.ルメール", jockey_page.jockey_name
    assert jockey_page.valid?
    assert jockey_page.exists?
  end

  test "find" do
    # setup
    jockey_pages = []
    jockey_pages << JockeyPage.new("05339", File.open("test/fixtures/files/jockey.05339.html").read)
    jockey_pages << JockeyPage.new("01014", File.open("test/fixtures/files/jockey.01014.html").read)
    jockey_pages << JockeyPage.new("01088", File.open("test/fixtures/files/jockey.01088.html").read)
    jockey_pages << JockeyPage.new("01114", File.open("test/fixtures/files/jockey.01114.html").read)
    jockey_pages << JockeyPage.new("01165", File.open("test/fixtures/files/jockey.01165.html").read)
    jockey_pages << JockeyPage.new("00894", File.open("test/fixtures/files/jockey.00894.html").read)
    jockey_pages << JockeyPage.new("01034", File.open("test/fixtures/files/jockey.01034.html").read)
    jockey_pages << JockeyPage.new("05203", File.open("test/fixtures/files/jockey.05203.html").read)
    jockey_pages << JockeyPage.new("01126", File.open("test/fixtures/files/jockey.01126.html").read)
    jockey_pages << JockeyPage.new("01019", File.open("test/fixtures/files/jockey.01019.html").read)
    jockey_pages << JockeyPage.new("01166", File.open("test/fixtures/files/jockey.01166.html").read)
    jockey_pages << JockeyPage.new("01018", File.open("test/fixtures/files/jockey.01018.html").read)
    jockey_pages << JockeyPage.new("01130", File.open("test/fixtures/files/jockey.01130.html").read)
    jockey_pages << JockeyPage.new("05386", File.open("test/fixtures/files/jockey.05386.html").read)
    jockey_pages << JockeyPage.new("01116", File.open("test/fixtures/files/jockey.01116.html").read)
    jockey_pages << JockeyPage.new("01154", File.open("test/fixtures/files/jockey.01154.html").read)

    # execute - 未保存時の検索
    jockey_pages_2 = JockeyPage.find_all

    # check - 未保存時は0件
    assert_equal 0, jockey_pages_2.length

    # execute - 保存してから検索
    jockey_pages.each { |j| j.save! }

    jockey_pages_2 = JockeyPage.find_all

    jockey_pages_2.each { |j| j.download_from_s3! }

    # check
    assert_equal 16, jockey_pages_2.length

    jockey_pages_2.each do |jockey_page_2|
      jockey_page = jockey_pages.find { |j| j.jockey_id == jockey_page_2.jockey_id }

      assert jockey_page_2.same?(jockey_page)
    end
  end

end
