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

  test "parse 1" do
    # precondition
    course_list_page = CourseListPage.download(2018, 7, 16)
    race_list_page = RaceListPage.download(course_list_page, "帯広競馬場", "ナイター", "https://www.oddspark.com/keiba/OneDayRaceList.do?raceDy=20180716&opTrackCd=03&sponsorCd=04")
    entry_list_page = EntryListPage.download(race_list_page, 1, "Ｃ２－５", "https://www.oddspark.com/keiba/RaceList.do?raceDy=20180716&opTrackCd=03&raceNb=1&sponsorCd=04")
    odds_win_page = OddsWinPage.download(entry_list_page, "https://www.oddspark.com/keiba/Odds.do?sponsorCd=04&raceDy=20180716&opTrackCd=03&raceNb=", File.open("test/fixtures/files/odds.20180716.1.win.html").read)

    # execute
    page_data = odds_win_page.parse

    # postcondition
    expected_data = {
      win: [
        { horse_number: 1, horse_name: "キタノショウナン", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190048", odds: "47.3".to_d },
        { horse_number: 2, horse_name: "ダイナユウヒメ", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190060", odds: "68.6".to_d },
        { horse_number: 3, horse_name: "カイオー", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190168", odds: "27.2".to_d },
        { horse_number: 4, horse_name: "ウノフクヒメ", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190155", odds: "3.1".to_d },
        { horse_number: 5, horse_name: "ワタシトマランサー", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190119", odds: "1.9".to_d },
        { horse_number: 6, horse_name: "ホクトペリドット", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190540", odds: "7.7".to_d },
        { horse_number: 7, horse_name: "デビットシャルマン", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190920", odds: "59.7".to_d },
        { horse_number: 8, horse_name: "テンカノサブロウ", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190906", odds: "5.1".to_d },
      ],
      place: [
        { horse_number: 1, horse_name: "キタノショウナン", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190048", odds: ["4.7".to_d, "8.1".to_d] },
        { horse_number: 2, horse_name: "ダイナユウヒメ", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190060", odds: ["8.0".to_d, "13.8".to_d] },
        { horse_number: 3, horse_name: "カイオー", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190168", odds: ["2.9".to_d, "4.9".to_d] },
        { horse_number: 4, horse_name: "ウノフクヒメ", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190155", odds: ["1.2".to_d, "1.7".to_d] },
        { horse_number: 5, horse_name: "ワタシトマランサー", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190119", odds: ["1.1".to_d, "1.5".to_d] },
        { horse_number: 6, horse_name: "ホクトペリドット", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190540", odds: ["1.3".to_d, "2.1".to_d] },
        { horse_number: 7, horse_name: "デビットシャルマン", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190920", odds: ["3.4".to_d, "5.8".to_d] },
        { horse_number: 8, horse_name: "テンカノサブロウ", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190906", odds: ["1.1".to_d, "1.6".to_d] },
      ]
    }

    assert_equal page_data, expected_data
  end

  test "parse 2" do
    # precondition
    course_list_page = CourseListPage.download(2018, 7, 16)
    race_list_page = RaceListPage.download(course_list_page, "帯広競馬場", "ナイター", "https://www.oddspark.com/keiba/OneDayRaceList.do?raceDy=20180716&opTrackCd=03&sponsorCd=04")
    entry_list_page = EntryListPage.download(race_list_page, 11, "Ｂ１－４", "https://www.oddspark.com/keiba/RaceList.do?raceDy=20180716&opTrackCd=03&raceNb=11&sponsorCd=04")
    odds_win_page = OddsWinPage.download(entry_list_page, "https://www.oddspark.com/keiba/Odds.do?sponsorCd=04&raceDy=20180716&opTrackCd=03&raceNb=11", File.open("test/fixtures/files/odds.20180716.11.win.html").read)

    # execute
    page_data = odds_win_page.parse

    # postcondition
    expected_data = {
      win: [
        { horse_number: 1, horse_name: "プレザントウェー", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2250190723", odds: "79.6".to_d },
        { horse_number: 2, horse_name: "オレワチャンピオン", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190150", odds: "3.5".to_d },
        { horse_number: 3, horse_name: "オレモスゴイ", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2210191261", odds: "33.4".to_d },
        { horse_number: 4, horse_name: "ホクショウマックス", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2230190220", odds: "2.6".to_d },
        { horse_number: 5, horse_name: "タフガイ", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2250191014", odds: "44.2".to_d },
        { horse_number: 6, horse_name: "ゴールドインパクト", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2260190395", odds: "6.3".to_d },
        { horse_number: 7, horse_name: "キタノサムライ", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2220190281", odds: "14.1".to_d },
        { horse_number: 8, horse_name: "オメガグレート", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2210191315", odds: "50.4".to_d },
        { horse_number: 9, horse_name: "ホクショウユヅル", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2240190135", odds: "3.6".to_d },
      ],
      place: [
        { horse_number: 1, horse_name: "プレザントウェー", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2250190723", odds: ["8.8".to_d, "19.3".to_d] },
        { horse_number: 2, horse_name: "オレワチャンピオン", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190150", odds: ["1.4".to_d, "2.6".to_d] },
        { horse_number: 3, horse_name: "オレモスゴイ", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2210191261", odds: ["2.9".to_d, "6.2".to_d] },
        { horse_number: 4, horse_name: "ホクショウマックス", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2230190220", odds: ["1.0".to_d, "1.2".to_d] },
        { horse_number: 5, horse_name: "タフガイ", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2250191014", odds: ["4.1".to_d, "8.9".to_d] },
        { horse_number: 6, horse_name: "ゴールドインパクト", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2260190395", odds: ["1.4".to_d, "2.6".to_d] },
        { horse_number: 7, horse_name: "キタノサムライ", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2220190281", odds: ["2.3".to_d, "4.6".to_d] },
        { horse_number: 8, horse_name: "オメガグレート", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2210191315", odds: ["5.6".to_d, "12.2".to_d] },
        { horse_number: 9, horse_name: "ホクショウユヅル", url: "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2240190135", odds: ["1.1".to_d, "1.7".to_d] },
      ],
      bracket_quinella: [
        { bracket_number: [1, 2], odds: "60.5".to_d },
        { bracket_number: [1, 3], odds: "247.5".to_d },
        { bracket_number: [1, 4], odds: "60.5".to_d },
        { bracket_number: [1, 5], odds: "151.2".to_d },
        { bracket_number: [1, 6], odds: "123.7".to_d },
        { bracket_number: [1, 7], odds: "209.4".to_d },
        { bracket_number: [1, 8], odds: "90.7".to_d },
        { bracket_number: [2, 3], odds: "42.5".to_d },
        { bracket_number: [2, 4], odds: "8.8".to_d },
        { bracket_number: [2, 5], odds: "82.5".to_d },
        { bracket_number: [2, 6], odds: "8.0".to_d },
        { bracket_number: [2, 7], odds: "23.2".to_d },
        { bracket_number: [2, 8], odds: "8.4".to_d },
        { bracket_number: [3, 4], odds: "35.3".to_d },
        { bracket_number: [3, 5], odds: "113.4".to_d },
        { bracket_number: [3, 6], odds: "38.8".to_d },
        { bracket_number: [3, 7], odds: "82.5".to_d },
        { bracket_number: [3, 8], odds: "41.8".to_d },
        { bracket_number: [4, 5], odds: "104.7".to_d },
        { bracket_number: [4, 6], odds: "7.4".to_d },
        { bracket_number: [4, 7], odds: "17.9".to_d },
        { bracket_number: [4, 8], odds: "3.9".to_d },
        { bracket_number: [5, 6], odds: "46.9".to_d },
        { bracket_number: [5, 7], odds: "113.4".to_d },
        { bracket_number: [5, 8], odds: "66.4".to_d },
        { bracket_number: [6, 7], odds: "15.0".to_d },
        { bracket_number: [6, 8], odds: "9.9".to_d },
        { bracket_number: [7, 8], odds: "17.3".to_d },
        { bracket_number: [8, 8], odds: "118.3".to_d },
      ]
    }

    assert_equal page_data, expected_data
  end

end
