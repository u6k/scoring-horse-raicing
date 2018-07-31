require 'test_helper'

class CrawlTest < ActionDispatch::IntegrationTest

  def setup
    @bucket = NetModule.get_s3_bucket
    @bucket.objects.batch_delete!

    SchedulePage.all.delete_all
  end

  test "download schedule page: case 2018-06" do
    # precondition
    assert_equal 0, SchedulePage.all.length

    assert_not @bucket.object("html/201806/schedule.html").exists?

    # execute
    `rails crawl:download_schedule_pages[2018,6]`

    # NOTE: 引数なしで、全期間をダウンロードする
    # `rails crawl:download_schedule_pages`

    # postcondition
    assert_equal 1, SchedulePage.all.length

    assert @bucket.object("html/201806/schedule.html").exists?
  end

end
