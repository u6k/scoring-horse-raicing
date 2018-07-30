require 'test_helper'

class SchedulePageTest < ActiveSupport::TestCase

  def setup
    @bucket = NetModule.get_s3_bucket
    @bucket.objects.batch_delete!
  end

  test "download" do
    # execute
    schedule_page = SchedulePage.download(2018, 6)

    # postcondition
    assert_equal 0, SchedulePage.all.length
    
    assert_equal "https://keiba.yahoo.co.jp/schedule/list/2018/?month=6", schedule_page.url
    assert_equal Time.zone.local(2018, 6, 1), schedule_page.datetime
    assert schedule_page.content.length > 0
    assert schedule_page.valid?
    assert_not @bucket.object("html/201806/schedule.html").exists?
  end

  test "download current month" do
    # precondition
    current_time = Time.zone.now

    # execute
    schedule_page = SchedulePage.download(current_time.year, current_time.month)

    # postcondition
    assert_equal 0, SchedulePage.all.length

    assert_equal "https://keiba.yahoo.co.jp/schedule/list/#{current_time.year}/?month=#{current_time.month}", schedule_page.url
    assert_equal Time.zone.local(current_time.year, current_time.month, 1), schedule_page.datetime
    assert schedule_page.content.length > 0
    assert schedule_page.valid?
    assert_not @bucket.object("html/#{current_time.strftime('%Y%m')}/schedule.html").exists?
  end

end
