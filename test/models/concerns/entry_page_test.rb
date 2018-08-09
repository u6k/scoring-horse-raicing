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

end
