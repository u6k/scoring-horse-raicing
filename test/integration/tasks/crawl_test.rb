require 'test_helper'

class CrawlTest < ActionDispatch::IntegrationTest

  def setup
    @bucket = NetModule.get_s3_bucket
    @bucket.objects.batch_delete!
  end

  test "download schedule page: case 2018-06" do
    # execute
    `rails crawl:download_schedule_pages[2018,6]`

    # NOTE: 引数なしで、全期間をダウンロードする
    # `rails crawl:download_schedule_pages`

    # check
    schedule_pages = SchedulePage.find_all

    assert_equal 1, schedule_pages.length

    schedule_page = schedule_pages[0]
    assert_equal Time.zone.local(2018, 6, 1), schedule_page.date
  end

  test "download schedule page: case 2018-06, and force download" do
    # setup
    schedule_page_html_201806 = File.open("test/fixtures/files/schedule.201806.html").read
    NetModule.put_s3_object(NetModule.get_s3_bucket, "html/schedule/schedule.201806.html", schedule_page_html_201806)

    assert_equal 1, SchedulePage.find_all.length

    # execute
    `rails crawl:download_schedule_pages[2018,6,false]`

    # check
    schedule_pages = SchedulePage.find_all

    assert_equal 1, schedule_pages.length

    schedule_page = schedule_pages[0]
    assert_equal Time.zone.local(2018, 6, 1), schedule_page.date
  end

  test "download schedule page: case 2018-06, and missing only" do
    # setup
    schedule_page_html_201806 = File.open("test/fixtures/files/schedule.201806.html").read
    NetModule.put_s3_object(NetModule.get_s3_bucket, "html/schedule/schedule.201806.html", schedule_page_html_201806)

    assert_equal 1, SchedulePage.find_all.length

    # execute
    `rails crawl:download_schedule_pages[2018,6,true]`

    # check
    schedule_pages = SchedulePage.find_all

    assert_equal 1, schedule_pages.length

    schedule_page = schedule_pages[0]
    assert_equal Time.zone.local(2018, 6, 1), schedule_page.date
  end

#  test "download race list page: case 2018-06" do
#    # precondition
#    html = File.open("test/fixtures/files/schedule.201806.html").read
#    schedule_page = SchedulePage.download(2018, 6, html)
#    schedule_page.save!
#
#    # execute
#    Rake::Task["crawl:download_race_list_pages"].invoke(2018, 6)
#
#    # NOTE: 引数なしで、全期間をダウンロードする
#    # Rake::Task["crawl:download_race_list_pages"].invoke
#
#    # postcondition
#    assert_equal 23, RaceListPage.all.length
#
#    assert @bucket.object("html/201806/20180602/東京/race_list.html").exists?
#    assert @bucket.object("html/201806/20180602/阪神/race_list.html").exists?
#    assert @bucket.object("html/201806/20180603/東京/race_list.html").exists?
#    assert @bucket.object("html/201806/20180603/阪神/race_list.html").exists?
#    assert @bucket.object("html/201806/20180609/東京/race_list.html").exists?
#    assert @bucket.object("html/201806/20180609/阪神/race_list.html").exists?
#    assert @bucket.object("html/201806/20180610/東京/race_list.html").exists?
#    assert @bucket.object("html/201806/20180610/阪神/race_list.html").exists?
#    assert @bucket.object("html/201806/20180616/函館/race_list.html").exists?
#    assert @bucket.object("html/201806/20180616/東京/race_list.html").exists?
#    assert @bucket.object("html/201806/20180616/阪神/race_list.html").exists?
#    assert @bucket.object("html/201806/20180617/函館/race_list.html").exists?
#    assert @bucket.object("html/201806/20180617/東京/race_list.html").exists?
#    assert @bucket.object("html/201806/20180617/阪神/race_list.html").exists?
#    assert @bucket.object("html/201806/20180623/函館/race_list.html").exists?
#    assert @bucket.object("html/201806/20180623/東京/race_list.html").exists?
#    assert @bucket.object("html/201806/20180623/阪神/race_list.html").exists?
#    assert @bucket.object("html/201806/20180624/函館/race_list.html").exists?
#    assert @bucket.object("html/201806/20180624/東京/race_list.html").exists?
#    assert @bucket.object("html/201806/20180624/阪神/race_list.html").exists?
#    assert @bucket.object("html/201806/20180630/函館/race_list.html").exists?
#    assert @bucket.object("html/201806/20180630/福島/race_list.html").exists?
#    assert @bucket.object("html/201806/20180630/中京/race_list.html").exists?
#  end
#
#  test "download result page: case 2018-06-24 東京" do
#    # precondition
#    schedule_page = SchedulePage.download(2018, 6)
#    schedule_page.save!
#
#    race_list_pages = schedule_page.download_race_list_pages
#    race_list_pages.each { |r| r.save! }
#
#    # execute
#    Rake::Task["crawl:download_result_pages"].invoke(2018, 6, 24, "東京")
#
#    # NOTE: year,monthのみ指定で、指定月をダウンロードする
#    # Rake::Task["crawl:download_result_pages"].invoke(2018, 6)
#    # NOTE: 引数なしで、全期間をダウンロードする
#    # Rake::Task["crawl:download_result_pages"].invoke
#
#    # postcondition
#    assert_equal 12, ResultPage.all.length
#
#    assert @bucket.object("html/201806/20180624/東京/1/result.html").exists?
#    assert @bucket.object("html/201806/20180624/東京/2/result.html").exists?
#    assert @bucket.object("html/201806/20180624/東京/3/result.html").exists?
#    assert @bucket.object("html/201806/20180624/東京/4/result.html").exists?
#    assert @bucket.object("html/201806/20180624/東京/5/result.html").exists?
#    assert @bucket.object("html/201806/20180624/東京/6/result.html").exists?
#    assert @bucket.object("html/201806/20180624/東京/7/result.html").exists?
#    assert @bucket.object("html/201806/20180624/東京/8/result.html").exists?
#    assert @bucket.object("html/201806/20180624/東京/9/result.html").exists?
#    assert @bucket.object("html/201806/20180624/東京/10/result.html").exists?
#    assert @bucket.object("html/201806/20180624/東京/11/result.html").exists?
#    assert @bucket.object("html/201806/20180624/東京/12/result.html").exists?
#  end

end
