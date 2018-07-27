require 'test_helper'

class OddsWinPageTest < ActiveSupport::TestCase

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

    entry_list_page = EntryListPage.download(race_list_page, 1, "Ｃ２－５", "https://www.oddspark.com/keiba/RaceList.do?raceDy=20180716&opTrackCd=03&raceNb=1&sponsorCd=04")
    entry_list_page.save!

    # execute
    odds_win_page = entry_list_page.download_odds_win_page

    # postcondition
    assert 0, OddsWinPage.all.length

    assert_equal "https://www.oddspark.com/keiba/Odds.do?sponsorCd=04&raceDy=20180716&opTrackCd=03&raceNb=1", odds_win_page.url
    assert odds_win_page.content.length > 0
    assert odds_win_page.entry_list_page.same?(entry_list_page)
    assert odds_win_page.valid?
    assert_not @bucket.object("race_list/20180716/帯広競馬場/1/odds_win_place_bracket_quinella.html").exists?
  end

end
