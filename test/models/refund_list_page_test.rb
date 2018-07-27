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

  test "download: invalid html" do
    # precondition
    course_list_page = CourseListPage.download(2018, 7, 16)
    course_list_page.save!

    race_list_page = RaceListPage.download(course_list_page, "帯広競馬場", "ナイター", "https://www.oddspark.com/keiba/OneDayRaceList.do?raceDy=20180716&opTrackCd=03&sponsorCd=04")
    race_list_page.save!

    # execute 1
    refund_list_page = RefundListPage.download(race_list_page, "https://www.oddspark.com/keiba/RaceRefund.do?sponsorCd=04&raceDy=19000101&opTrackCd=03")

    # postcondition 1
    assert refund_list_page.content.length > 0
    assert refund_list_page.invalid?
    assert_equal "Invalid html", refund_list_page.errors[:url][0]
    assert_not @bucket.object("race_list/20180716/帯広競馬場/refund_list.html").exists?

    assert_equal 0, RefundListPage.all.length

    # execute 2
    assert_raise ActiveRecord::RecordInvalid, "Url Invalid html" do
      refund_list_page.save!
    end

    # postcondition 2
    assert_not @bucket.object("race_list/20180716/帯広競馬場/refund_list.html").exists?

    assert_equal 0, RefundListPage.all.length
  end

  test "parse" do
    # precondition
    course_list_page = CourseListPage.new(date: Time.zone.local(2018, 7, 16), url: "https://www.example.com/course_list_page.html")
    race_list_page = course_list_page.race_list_pages.build(url: "https://www.example.com/race_list_page.html", course_name: "aaa")
    refund_list_page = RefundListPage.download(race_list_page, "https://www.oddspark.com/keiba/RaceRefund.do?sponsorCd=04&raceDy=20180716&opTrackCd=03", File.open("test/fixtures/files/refund_list_page.20180716.html").read)

    # execute 1
    data = refund_list_page.parse

    # postcondition
    expected_data = [
      {
        race_number: 1,
        race_name: "Ｃ２－５",
        url: "https://www.oddspark.com/keiba/RaceList.do?sponsorCd=04&raceDy=20180716&opTrackCd=03&raceNb=1",
        refund: {
          # 単勝
          win: { horse_number: "6", money: 770 },
          # 複勝
          place: [
            { horse_number: "6", money: 140 },
            { horse_number: "8", money: 120 },
            { horse_number: "4", money: 130 },
          ],
          # 枠単(bracket exacta) 発売なし
          # 枠連(bracket quinella) 発売なし
          # 馬連
          quinella: { horse_number: "6-8", money: 1360 },
          # 馬単
          exacta: { horse_number: "6-8", money: 1900 },
          # ワイド
          quinella_place: [
            { horse_number: "6-8", money: 270 },
            { horse_number: "4-6", money: 280 },
            { horse_number: "4-8", money: 320 },
          ],
          # 3連複
          trio: { horse_number: "4-6-8", money: 1650 },
          # 3連単
          trifecta: { horse_number: "6-8-4", money: 9660 },
        }
      },
      {
        race_number: 2,
        race_name: "有香ちゃん初北海道記念２歳新馬",
        url: "https://www.oddspark.com/keiba/RaceList.do?sponsorCd=04&raceDy=20180716&opTrackCd=03&raceNb=2",
        refund: {
          win: { horse_number: "2", money: 2440 },
          place: [
            { horse_number: "2", money: 240 },
            { horse_number: "1", money: 100 },
            { horse_number: "7", money: 190 },
          ],
          quinella: { horse_number: "1-2", money: 550 },
          exacta: { horse_number: "2-1", money: 3480 },
          quinella_place: [
            { horse_number: "1-2", money: 160 },
            { horse_number: "2-7", money: 250 },
            { horse_number: "1-7", money: 140 },
          ],
          trio: { horse_number: "1-2-7", money: 530 },
          trifecta: { horse_number: "2-1-7", money: 12490 },
        }
      },
      {
        race_number: 3,
        race_name: "第５回　姉妹都市大分カイピー杯２歳Ｄ－７",
        url: "https://www.oddspark.com/keiba/RaceList.do?sponsorCd=04&raceDy=20180716&opTrackCd=03&raceNb=3",
        refund: {
          win: { horse_number: "2", money: 530 },
          place: [
            { horse_number: "2", money: 580 },
            { horse_number: "1", money: 1130 },
          ],
          quinella: { horse_number: "1-2", money: 3110 },
          exacta: { horse_number: "2-1", money: 7210 },
          quinella_place: [
            { horse_number: "1-2", money: 1490 },
            { horse_number: "2-3", money: 790 },
            { horse_number: "1-3", money: 3020 },
          ],
          trio: { horse_number: "1-2-3", money: 6990 },
          trifecta: { horse_number: "2-1-3", money: 39100 },
        }
      },
      {
        race_number: 4,
        race_name: "ありがとう十勝！鈴木啓太記念２歳Ｃ－７",
        url: "https://www.oddspark.com/keiba/RaceList.do?sponsorCd=04&raceDy=20180716&opTrackCd=03&raceNb=4",
        refund: {
          win: { horse_number: "5", money: 650 },
          place: [
            { horse_number: "5", money: 140 },
            { horse_number: "8", money: 120 },
            { horse_number: "6", money: 140 },
          ],
          bracket_quinella: { horse_number: "5-8", money: 910 },
          quinella: { horse_number: "5-8", money: 1130 },
          exacta: { horse_number: "5-8", money: 2970 },
          quinella_place: [
            { horse_number: "5-8", money: 400 },
            { horse_number: "5-6", money: 330 },
            { horse_number: "6-8", money: 270 },
          ],
          trio: { horse_number: "5-6-8", money: 760 },
          trifecta: { horse_number: "5-8-6", money: 6240 },
        }
      },
      {
        race_number: 5,
        race_name: "２歳Ｂ－２",
        url: "https://www.oddspark.com/keiba/RaceList.do?sponsorCd=04&raceDy=20180716&opTrackCd=03&raceNb=5",
        refund: {
          win: { horse_number: "3", money: 1690 },
          place: [
            { horse_number: "3", money: 790 },
            { horse_number: "4", money: 430 },
            { horse_number: "6", money: 160 },
          ],
          bracket_quinella: { horse_number: "3-4", money: 12580 },
          quinella: { horse_number: "3-4", money: 8540 },
          exacta: { horse_number: "3-4", money: 28560 },
          quinella_place: [
            { horse_number: "3-4", money: 3220 },
            { horse_number: "3-6", money: 2090 },
            { horse_number: "4-6", money: 3360 },
          ],
          trio: { horse_number: "3-4-6", money: 15470 },
          trifecta: { horse_number: "3-4-6", money: 159310 },
        }
      },
      {
        race_number: 6,
        race_name: "Ｃ１－９",
        url: "https://www.oddspark.com/keiba/RaceList.do?sponsorCd=04&raceDy=20180716&opTrackCd=03&raceNb=6",
        refund: {
          win: { horse_number: "7", money: 140 },
          place: [
            { horse_number: "7", money: 100 },
            { horse_number: "3", money: 130 },
          ],
          quinella: { horse_number: "3-7", money: 190 },
          exacta: { horse_number: "7-3", money: 350 },
          quinella_place: [
            { horse_number: "3-7", money: 150 },
            { horse_number: "5-7", money: 880 },
            { horse_number: "3-5", money: 1000 },
          ],
          trio: { horse_number: "3-5-7", money: 1460 },
          trifecta: { horse_number: "7-3-5", money: 1880 },
        }
      },
      {
        race_number: 7,
        race_name: "つなぐねこ杯Ｃ１－８",
        url: "https://www.oddspark.com/keiba/RaceList.do?sponsorCd=04&raceDy=20180716&opTrackCd=03&raceNb=7",
        refund: {
          win: { horse_number: "6", money: 640 },
          place: [
            { horse_number: "6", money: 220 },
            { horse_number: "3", money: 220 },
            { horse_number: "1", money: 160 },
          ],
          bracket_quinella: { horse_number: "3-6", money: 3080 },
          quinella: { horse_number: "3-6", money: 2570 },
          exacta: { horse_number: "6-3", money: 5550 },
          quinella_place: [
            { horse_number: "3-6", money: 860 },
            { horse_number: "1-6", money: 300 },
            { horse_number: "1-3", money: 490 },
          ],
          trio: { horse_number: "1-3-6", money: 2810 },
          trifecta: { horse_number: "6-3-1", money: 20670 },
        }
      },
      {
        race_number: 8,
        race_name: "Ｂ４－５",
        url: "https://www.oddspark.com/keiba/RaceList.do?sponsorCd=04&raceDy=20180716&opTrackCd=03&raceNb=8",
        refund: {
          win: { horse_number: "6", money: 240 },
          place: [
            { horse_number: "6", money: 130 },
            { horse_number: "4", money: 190 },
          ],
          quinella: { horse_number: "4-6", money: 440 },
          exacta: { horse_number: "6-4", money: 1240 },
          quinella_place: [
            { horse_number: "4-6", money: 190 },
            { horse_number: "5-6", money: 390 },
            { horse_number: "4-5", money: 430 },
          ],
          trio: { horse_number: "4-5-6", money: 850 },
          trifecta: { horse_number: "6-4-5", money: 5250 },
        }
      },
      {
        race_number: 9,
        race_name: "Ｂ３－５",
        url: "https://www.oddspark.com/keiba/RaceList.do?sponsorCd=04&raceDy=20180716&opTrackCd=03&raceNb=9",
        refund: {
          win: { horse_number: "3", money: 170 },
          place: [
            { horse_number: "3", money: 120 },
            { horse_number: "4", money: 160 },
          ],
          quinella: { horse_number: "3-4", money: 280 },
          exacta: { horse_number: "3-4", money: 460 },
          quinella_place: [
            { horse_number: "3-4", money: 160 },
            { horse_number: "3-6", money: 310 },
            { horse_number: "4-6", money: 410 },
          ],
          trio: { horse_number: "3-4-6", money: 550 },
          trifecta: { horse_number: "3-4-6", money: 1700 },
        }
      },
      {
        race_number: 10,
        race_name: "さざなみ特別Ａ２－１",
        url: "https://www.oddspark.com/keiba/RaceList.do?sponsorCd=04&raceDy=20180716&opTrackCd=03&raceNb=10",
        refund: {
          win: { horse_number: "3", money: 370 },
          place: [
            { horse_number: "3", money: 150 },
            { horse_number: "6", money: 210 },
            { horse_number: "2", money: 340 },
          ],
          bracket_quinella: { horse_number: "3-6", money: 1080 },
          quinella: { horse_number: "3-6", money: 1070 },
          exacta: { horse_number: "3-6", money: 2440 },
          quinella_place: [
            { horse_number: "3-6", money: 510 },
            { horse_number: "2-3", money: 890 },
            { horse_number: "2-6", money: 1150 },
          ],
          trio: { horse_number: "2-3-6", money: 4340 },
          trifecta: { horse_number: "3-6-2", money: 19320 },
        }
      },
      {
        race_number: 11,
        race_name: "Ｂ１－４",
        url: "https://www.oddspark.com/keiba/RaceList.do?sponsorCd=04&raceDy=20180716&opTrackCd=03&raceNb=11",
        refund: {
          win: { horse_number: "4", money: 260 },
          place: [
            { horse_number: "4", money: 100 },
            { horse_number: "9", money: 110 },
            { horse_number: "2", money: 140 },
          ],
          bracket_quinella: { horse_number: "4-8", money: 390 },
          quinella: { horse_number: "4-9", money: 330 },
          exacta: { horse_number: "4-9", money: 740 },
          quinella_place: [
            { horse_number: "4-9", money: 170 },
            { horse_number: "2-4", money: 250 },
            { horse_number: "2-9", money: 240 },
          ],
          trio: { horse_number: "2-4-9", money: 430 },
          trifecta: { horse_number: "4-9-2", money: 2380 },
        }
      }
    ]

    assert_equal data, expected_data
  end

  test "save, and overwrite" do
    # precondition
    course_list_page = CourseListPage.download(2018, 7, 16)
    course_list_page.save!

    race_list_page = RaceListPage.download(course_list_page, "帯広競馬場", "ナイター", "https://www.oddspark.com/keiba/OneDayRaceList.do?raceDy=20180716&opTrackCd=03&sponsorCd=04")
    race_list_page.save!

    # execute 1
    refund_list_page = RefundListPage.download(race_list_page, "https://www.oddspark.com/keiba/RaceRefund.do?sponsorCd=04&raceDy=20180716&opTrackCd=03", File.open("test/fixtures/files/refund_list_page.20180716.html").read)
    refund_list_page.save!

    # postcondition 1
    assert_equal 1, RefundListPage.all.length

    # execute 2
    refund_list_page_2 = RefundListPage.download(race_list_page, "https://www.oddspark.com/keiba/RaceRefund.do?sponsorCd=04&raceDy=20180716&opTrackCd=03", File.open("test/fixtures/files/refund_list_page.20180716.html").read)
    refund_list_page_2.save!

    # postcondition 2
    assert_equal 1, RefundListPage.all.length

    assert refund_list_page.same?(refund_list_page_2)
  end

  test "find all" do
    # precondition
    course_list_page = CourseListPage.download(2018, 7, 16)
    course_list_page.save!

    race_list_page = RaceListPage.download(course_list_page, "aaa", "bbb", "https://www.oddspark.com/keiba/OneDayRaceList.do?raceDy=20180716&opTrackCd=03&sponsorCd=04")
    race_list_page.save!

    refund_list_page = race_list_page.download_refund_list_page
    refund_list_page.save!

    # execute
    refund_list_page_db = race_list_page.refund_list_page

    # postcondition
    assert_equal 1, RefundListPage.all.length

    assert refund_list_page.same?(refund_list_page_db)
  end

end
