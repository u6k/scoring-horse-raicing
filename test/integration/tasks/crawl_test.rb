require 'test_helper'
require 'rake'

class CrawlTest < ActionDispatch::IntegrationTest

  def setup
    Rails.application.load_tasks

    @bucket = NetModule.get_s3_bucket
    @bucket.objects.batch_delete!
  end

  def teardown
    Rake::Task["crawl:download_schedule_pages"].clear
  end

  test "download schedule page: case 2018-06" do
    # precondition
    assert_equal 0, SchedulePage.all.length

    assert_not @bucket.object("html/201806/schedule.html").exists?

    # execute
    Rake::Task["crawl:download_schedule_pages"].invoke(2018, 6)

    # NOTE: 引数なしで、全期間をダウンロードする
    # Rake::Task["crawl:download_schedule_pages"].invoke

    # postcondition
    assert_equal 1, SchedulePage.all.length

    assert @bucket.object("html/201806/schedule.html").exists?
  end

end
