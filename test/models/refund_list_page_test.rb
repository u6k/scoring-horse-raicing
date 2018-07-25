require 'test_helper'

class RefundListPageTest < ActiveSupport::TestCase

  def setup
    @bucket = NetModule.get_s3_bucket
    @bucket.objects.batch_delete!
  end

  test "download" do
    # precondition
    course_list_page = CourseListPage.download(2018, 7, 16)
    course_list_page.save!

    race_list_page = RaceListPage.download(course_list_page, "帯広競馬場", "ナイター", "https://www.oddspark.com/keiba/OneDayRaceList.do?raceDy=20180716&opTrackCd=03&sponsorCd=04")
    race_list_page.save!

    # execute 1
    refund_list_page = race_list_page.download_refund_list_page

    # postcondition
    assert_equal "https://www.oddspark.com/keiba/RaceRefund.do?sponsorCd=04&raceDy=20180716&opTrackCd=03", refund_list_page.url
    assert refund_list_page.content.length > 0
    assert refund_list_page.race_list_page.same?(race_list_page)
    assert refund_list_page.valid?
    assert_not @bucket.object("race_list/20180716/帯広競馬場/refund_list.html").exists?

    assert 0, RefundListPage.all.length

    # execute 2
    refund_list_page.save!

    # postcondition 2
    assert_equal 1, RefundListPage.all.length

    assert refund_list_page.same?(race_list_page.refund_list_page)

    assert @bucket.object("race_list/20180716/帯広競馬場/refund_list.html").exists?
  end

end
