require 'test_helper'

class EntryPageTest < ActiveSupport::TestCase

  def setup
    @bucket = NetModule.get_s3_bucket
    @bucket.objects.batch_delete!
  end

  test "download" do
    # setup
    result_page_html = File.open("test/fixtures/files/result.20180624.hanshin.1.html").read
    result_page = ResultPage.new("1809030801", result_html)

    # execute - インスタンス化
    entry_page = result_page.entry_page

    # check
    assert_equal 0, EntryPage.find_all.length

    assert_equal "1809030801", entry_page.entry_id
    assert_nil entry_page.entries
    assert_not entry_page.valid?
    assert_not entry_page.exists?

    # execute - ダウンロード
    entry_page.download_from_web!

    # check
    assert_equal 0, EntryPage.find_all.length

    assert_equal "1809030801", entry_page.entry_id
    assert_equal 16, entry_page.entries.length
    assert entry_page.valid?
    assert_not entry_page.exists?

    # execute - 保存
    entry_page.save!

    # check
    assert_equal 1, EntryPage.find_all.length

    assert entry_page.valid?
    assert entry_page.exists?

    # execute - 再インスタンス化
    result_page = ResultPage.new("1809030801", result_html)
    entry_page_2 = result_page.entry_page

    # check
    assert_equal 1, EntryPage.find_all.length

    assert_equal "1809030801", entry_page_2.entry_id
    assert_nil entry_page_2.entries
    assert_not entry_page_2.valid?
    assert entry_page_2.exists?

    # execute - 再ダウンロード
    entry_page_2.download_from_s3!

    # check
    assert_equal 1, EntryPage.find_all.length

    assert_equal "1809030801", entry_page_2.entry_id
    assert_equal 16, entry_page_2.entries.length
    assert entry_page_2.valid?
    assert entry_page_2.exists?

    # execute - 上書き保存
    entry_page_2.save!

    # check
    assert_equal 1, EntryPage.find_all.length
  end

  test "download: case invalid html" do
    # execute - 不正なエントリーIDのページをインスタンス化
    entry_page = EntryPage.new("0000000000")

    # check
    assert_equal 0, EntryPage.find_all.length

    assert_equal "0000000000", entry_page.entry_id
    assert_nil entry_page.entries
    assert_not entry_page.valid?
    assert_not entry_page.exists?

    # execute - ダウンロード -> 失敗
    entry_page.download_from_web!

    # check
    assert_equal 0, EntryPage.find_all.length

    assert_equal "0000000000", entry_page.entry_id
    assert_nil entry_page.entries
    assert_not entry_page.valid?
    assert_not entry_page.exists?

    # execute - 保存 -> 失敗
    assert_raises "Invalid" do
      entry_page.save!
    end

    # check
    assert_equal 0, EntryPage.find_all.length

    assert_not entry_page.valid?
    assert_not entry_page.exists?
  end

  test "parse" do
    # setup
    entry_page_html = File.open("test/fixtures/files/entry.20180624.hanshin.1.html").read

    # execute
    entry_page = EntryPage.new("1809030801", entry_page_html)

    # check
    assert_equal "1809030801", entry_page.entry_id
    assert_equal 16, entry_page.entries.length
    assert entry_page.valid?
    assert_not entry_page.exists?

    entry = entry_page.entries[0]
    assert_equal 1, entry[:bracket_number]
    assert_equal 1, entry[:horse_number]
    assert_equal "2015104308", entry[:horse].horse_id
    assert_equal "01120", entry[:trainer].trainer_id
    assert_equal "05339", entry[:jockey].jockey_id

    entry = entry_page.entries[1]
    assert_equal 1, entry[:bracket_number]
    assert_equal 2, entry[:horse_number]
    assert_equal "2015104964", entry[:horse].horse_id
    assert_equal "01022", entry[:trainer].trainer_id
    assert_equal "01014", entry[:jockey].jockey_id

    entry = entry_page.entries[2]
    assert_equal 2, entry[:bracket_number]
    assert_equal 3, entry[:horse_number]
    assert_equal "2015100632", entry[:horse].horse_id
    assert_equal "01046", entry[:trainer].trainer_id
    assert_equal "01088", entry[:jockey].jockey_id

    entry = entry_page.entries[3]
    assert_equal 2, entry[:bracket_number]
    assert_equal 4, entry[:horse_number]
    assert_equal "2015100586", entry[:horse].horse_id
    assert_equal "01140", entry[:trainer].trainer_id
    assert_equal "01114", entry[:jockey].jockey_id

    entry = entry_page.entries[4]
    assert_equal 3, entry[:bracket_number]
    assert_equal 5, entry[:horse_number]
    assert_equal "2015103335", entry[:horse].horse_id
    assert_equal "01041", entry[:trainer].trainer_id
    assert_equal "01165", entry[:jockey].jockey_id

    entry = entry_page.entries[5]
    assert_equal 3, entry[:bracket_number]
    assert_equal 6, entry[:horse_number]
    assert_equal "2015104928", entry[:horse].horse_id
    assert_equal "01073", entry[:trainer].trainer_id
    assert_equal "00894", entry[:jockey].jockey_id

    entry = entry_page.entries[6]
    assert_equal 4, entry[:bracket_number]
    assert_equal 7, entry[:horse_number]
    assert_equal "2015106259", entry[:horse].horse_id
    assert_equal "01078", entry[:trainer].trainer_id
    assert_equal "01034", entry[:jockey].jockey_id

    entry = entry_page.entries[7]
    assert_equal 4, entry[:bracket_number]
    assert_equal 8, entry[:horse_number]
    assert_equal "2015102694", entry[:horse].horse_id
    assert_equal "01104", entry[:trainer].trainer_id
    assert_equal "05203", entry[:jockey].jockey_id

    entry = entry_page.entries[8]
    assert_equal 5, entry[:bracket_number]
    assert_equal 9, entry[:horse_number]
    assert_equal "2015102837", entry[:horse].horse_id
    assert_equal "01050", entry[:trainer].trainer_id
    assert_equal "01126", entry[:jockey].jockey_id

    entry = entry_page.entries[9]
    assert_equal 5, entry[:bracket_number]
    assert_equal 10, entry[:horse_number]
    assert_equal "2015105363", entry[:horse].horse_id
    assert_equal "01138", entry[:trainer].trainer_id
    assert_equal "01019", entry[:jockey].jockey_id

    entry = entry_page.entries[10]
    assert_equal 6, entry[:bracket_number]
    assert_equal 11, entry[:horse_number]
    assert_equal "2015101618", entry[:horse].horse_id
    assert_equal "01066", entry[:trainer].trainer_id
    assert_equal "01166", entry[:jockey].jockey_id

    entry = entry_page.entries[11]
    assert_equal 6, entry[:bracket_number]
    assert_equal 12, entry[:horse_number]
    assert_equal "2015102853", entry[:horse].horse_id
    assert_equal "01111", entry[:trainer].trainer_id
    assert_equal "01018", entry[:jockey].jockey_id

    entry = entry_page.entries[12]
    assert_equal 7, entry[:bracket_number]
    assert_equal 13, entry[:horse_number]
    assert_equal "2015103462", entry[:horse].horse_id
    assert_equal "00356", entry[:trainer].trainer_id
    assert_equal "01130", entry[:jockey].jockey_id

    entry = entry_page.entries[13]
    assert_equal 7, entry[:bracket_number]
    assert_equal 14, entry[:horse_number]
    assert_equal "2015103590", entry[:horse].horse_id
    assert_equal "01157", entry[:trainer].trainer_id
    assert_equal "05386", entry[:jockey].jockey_id

    entry = entry_page.entries[14]
    assert_equal 8, entry[:bracket_number]
    assert_equal 15, entry[:horse_number]
    assert_equal "2015104979", entry[:horse].horse_id
    assert_equal "00438", entry[:trainer].trainer_id
    assert_equal "01116", entry[:jockey].jockey_id

    entry = entry_page.entries[15]
    assert_equal 8, entry[:bracket_number]
    assert_equal 16, entry[:horse_number]
    assert_equal "2015103557", entry[:horse].horse_id
    assert_equal "01022", entry[:trainer].trainer_id
    assert_equal "01154", entry[:jockey].jockey_id
  end

  test "parse: invalid html" do
    # execute
    entry_page = EntryPage.new("0000000000", "Invalid html")

    # check
    assert_equal "0000000000", entry_page.entry_id
    assert_nil entry_page.entries
    assert_not entry_page.valid?
    assert_not entry_page.exists?
  end

  test "save, and overwrite" do
    # setup
    entry_page_html = File.open("test/fixtures/files/entry.20180624.hanshin.1.html").read

    # execute - インスタンス化 & パース
    entry_page = EntryPage.new("1809030801", entry_page_html)

    # check
    assert_equal 0, EntryPage.find_all.length

    assert_equal "1809030801", entry_page.entry_id
    assert_equal 16, entry_page.entries.length
    assert entry_page.valid?
    assert_not entry_page.exists?

    # execute - 保存
    entry_page.save!

    # check
    assert_equal 1, EntryPage.find_all.length

    assert entry_page.valid?
    assert entry_page.exists?

    # execute - 再ダウンロード
    entry_page.download_from_web!

    # check
    assert_equal 1, EntryPage.find_all.length

    assert entry_page.valid?
    assert entry_page.exists?

    # execute - 上書き保存
    entry_page.save!

    # check
    assert_equal 1, EntryPage.find_all.length

    assert entry_page.valid?
    assert entry_page.exists?
  end

  test "save: invalid" do
    # execute - インスタンス化 && ダウンロード && パース -> 失敗
    entry_page = EntryPage.new("0000000000", "Invalid html")

    # check
    assert_equal 0, EntryPage.find_all.length

    assert_equal "0000000000", entry_page.entry_id
    assert_nil entry_page.entries
    assert_not entry_page.valid?
    assert_not entry_page.exists?

    # execute - 保存しようとして例外がスローされる
    assert_raises "Invalid" do
      entry_page.save!
    end

    # check
    assert_equal 0, EntryPage.find_all.length

    assert_not entry_page.valid?
    assert_not entry_page.exists?
  end

end
