require 'test_helper'

class EntryListPageTest < ActiveSupport::TestCase

  def setup
    @bucket = NetModule.get_s3_bucket
    @bucket.objects.batch_delete!
  end

  test "download entry list page" do
    # precondition
    course_list_page = CourseListPage.download(2018, 7, 16)
    course_list_page.save!

    race_list_pages = course_list_page.download_race_list_pages
    race_list_pages.each { |r| r.save! }

    # execute 1
    entry_list_pages = race_list_pages[0].download_entry_list_pages

    # postcondition 1
    assert_equal 11, entry_list_pages.length

    entry_list_page = entry_list_pages[0]
    assert_equal 1, entry_list_page.race_number
    assert_equal "Ｃ２－５", entry_list_page.race_name
    assert_equal "https://www.oddspark.com/keiba/RaceList.do?raceDy=20180716&opTrackCd=03&raceNb=1&sponsorCd=04", entry_list_page.url
    assert entry_list_page.content.length > 0
    assert entry_list_page.race_list_page.same?(race_list_pages[0])
    assert entry_list_page.valid?
    assert_not @bucket.object("race_list/20180716/帯広競馬場/1/entry_list.html").exists?

    entry_list_page = entry_list_pages[1]
    assert_equal 2, entry_list_page.race_number
    assert_equal "有香ちゃん初北海道記念２歳新馬", entry_list_page.race_name
    assert_equal "https://www.oddspark.com/keiba/RaceList.do?raceDy=20180716&opTrackCd=03&raceNb=2&sponsorCd=04", entry_list_page.url
    assert entry_list_page.content.length > 0
    assert entry_list_page.race_list_page.same?(race_list_pages[0])
    assert entry_list_page.valid?
    assert_not @bucket.object("race_list/20180716/帯広競馬場/2/entry_list.html").exists?

    entry_list_page = entry_list_pages[2]
    assert_equal 3, entry_list_page.race_number
    assert_equal "第５回　姉妹都市大分カイピー杯２歳Ｄ－７", entry_list_page.race_name
    assert_equal "https://www.oddspark.com/keiba/RaceList.do?raceDy=20180716&opTrackCd=03&raceNb=3&sponsorCd=04", entry_list_page.url
    assert entry_list_page.content.length > 0
    assert entry_list_page.race_list_page.same?(race_list_pages[0])
    assert entry_list_page.valid?
    assert_not @bucket.object("race_list/20180716/帯広競馬場/3/entry_list.html").exists?

    entry_list_page = entry_list_pages[3]
    assert_equal 4, entry_list_page.race_number
    assert_equal "ありがとう十勝！鈴木啓太記念２歳Ｃ－７", entry_list_page.race_name
    assert_equal "https://www.oddspark.com/keiba/RaceList.do?raceDy=20180716&opTrackCd=03&raceNb=4&sponsorCd=04", entry_list_page.url
    assert entry_list_page.content.length > 0
    assert entry_list_page.race_list_page.same?(race_list_pages[0])
    assert entry_list_page.valid?
    assert_not @bucket.object("race_list/20180716/帯広競馬場/4/entry_list.html").exists?

    entry_list_page = entry_list_pages[4]
    assert_equal 5, entry_list_page.race_number
    assert_equal "２歳Ｂ－２", entry_list_page.race_name
    assert_equal "https://www.oddspark.com/keiba/RaceList.do?raceDy=20180716&opTrackCd=03&raceNb=5&sponsorCd=04", entry_list_page.url
    assert entry_list_page.content.length > 0
    assert entry_list_page.race_list_page.same?(race_list_pages[0])
    assert entry_list_page.valid?
    assert_not @bucket.object("race_list/20180716/帯広競馬場/5/entry_list.html").exists?

    entry_list_page = entry_list_pages[5]
    assert_equal 6, entry_list_page.race_number
    assert_equal "Ｃ１－９", entry_list_page.race_name
    assert_equal "https://www.oddspark.com/keiba/RaceList.do?raceDy=20180716&opTrackCd=03&raceNb=6&sponsorCd=04", entry_list_page.url
    assert entry_list_page.content.length > 0
    assert entry_list_page.race_list_page.same?(race_list_pages[0])
    assert entry_list_page.valid?
    assert_not @bucket.object("race_list/20180716/帯広競馬場/6/entry_list.html").exists?

    entry_list_page = entry_list_pages[6]
    assert_equal 7, entry_list_page.race_number
    assert_equal "つなぐねこ杯Ｃ１－８", entry_list_page.race_name
    assert_equal "https://www.oddspark.com/keiba/RaceList.do?raceDy=20180716&opTrackCd=03&raceNb=7&sponsorCd=04", entry_list_page.url
    assert entry_list_page.content.length > 0
    assert entry_list_page.race_list_page.same?(race_list_pages[0])
    assert entry_list_page.valid?
    assert_not @bucket.object("race_list/20180716/帯広競馬場/7/entry_list.html").exists?

    entry_list_page = entry_list_pages[7]
    assert_equal 8, entry_list_page.race_number
    assert_equal "Ｂ４－５", entry_list_page.race_name
    assert_equal "https://www.oddspark.com/keiba/RaceList.do?raceDy=20180716&opTrackCd=03&raceNb=8&sponsorCd=04", entry_list_page.url
    assert entry_list_page.content.length > 0
    assert entry_list_page.race_list_page.same?(race_list_pages[0])
    assert entry_list_page.valid?
    assert_not @bucket.object("race_list/20180716/帯広競馬場/8/entry_list.html").exists?

    entry_list_page = entry_list_pages[8]
    assert_equal 9, entry_list_page.race_number
    assert_equal "Ｂ３－５", entry_list_page.race_name
    assert_equal "https://www.oddspark.com/keiba/RaceList.do?raceDy=20180716&opTrackCd=03&raceNb=9&sponsorCd=04", entry_list_page.url
    assert entry_list_page.content.length > 0
    assert entry_list_page.race_list_page.same?(race_list_pages[0])
    assert entry_list_page.valid?
    assert_not @bucket.object("race_list/20180716/帯広競馬場/9/entry_list.html").exists?

    entry_list_page = entry_list_pages[9]
    assert_equal 10, entry_list_page.race_number
    assert_equal "さざなみ特別Ａ２－１", entry_list_page.race_name
    assert_equal "https://www.oddspark.com/keiba/RaceList.do?raceDy=20180716&opTrackCd=03&raceNb=10&sponsorCd=04", entry_list_page.url
    assert entry_list_page.content.length > 0
    assert entry_list_page.race_list_page.same?(race_list_pages[0])
    assert entry_list_page.valid?
    assert_not @bucket.object("race_list/20180716/帯広競馬場/10/entry_list.html").exists?

    entry_list_page = entry_list_pages[10]
    assert_equal 11, entry_list_page.race_number
    assert_equal "Ｂ１－４", entry_list_page.race_name
    assert_equal "https://www.oddspark.com/keiba/RaceList.do?raceDy=20180716&opTrackCd=03&raceNb=11&sponsorCd=04", entry_list_page.url
    assert entry_list_page.content.length > 0
    assert entry_list_page.race_list_page.same?(race_list_pages[0])
    assert entry_list_page.valid?
    assert_not @bucket.object("race_list/20180716/帯広競馬場/11/entry_list.html").exists?

    assert_equal 0, EntryListPage.all.length

    # execute 2
    entry_list_pages.each { |e| e.save! }

    # postcondition 2
    assert_equal 11, EntryListPage.all.length

    race_list_pages[0].entry_list_pages.each do |entry_list_page_db|
      entry_list_page = entry_list_pages.find { |e| e.url == entry_list_page_db.url }

      assert entry_list_page.same?(entry_list_page_db)
    end

    assert @bucket.object("race_list/20180716/帯広競馬場/1/entry_list.html").exists?
    assert @bucket.object("race_list/20180716/帯広競馬場/2/entry_list.html").exists?
    assert @bucket.object("race_list/20180716/帯広競馬場/3/entry_list.html").exists?
    assert @bucket.object("race_list/20180716/帯広競馬場/4/entry_list.html").exists?
    assert @bucket.object("race_list/20180716/帯広競馬場/5/entry_list.html").exists?
    assert @bucket.object("race_list/20180716/帯広競馬場/6/entry_list.html").exists?
    assert @bucket.object("race_list/20180716/帯広競馬場/7/entry_list.html").exists?
    assert @bucket.object("race_list/20180716/帯広競馬場/8/entry_list.html").exists?
    assert @bucket.object("race_list/20180716/帯広競馬場/9/entry_list.html").exists?
    assert @bucket.object("race_list/20180716/帯広競馬場/10/entry_list.html").exists?
    assert @bucket.object("race_list/20180716/帯広競馬場/11/entry_list.html").exists?

    # execute 3
    entry_list_pages_2 = race_list_pages[0].download_entry_list_pages

    # postcondition 3
    assert_equal 11, EntryListPage.all.length

    race_list_pages[0].entry_list_pages.each do |entry_list_page_db|
      entry_list_page_2 = entry_list_pages_2.find { |e| e.url == entry_list_page_db.url }

      assert entry_list_page_2.same?(entry_list_page_db)
    end

    # execute 4
    entry_list_pages_2.each { |e| e.save! }

    # postcondition 4
    assert_equal 11, EntryListPage.all.length
  end

  test "download entry list page: invalid html" do
    # precondition
    course_list_page = CourseListPage.download(2018, 7, 16)
    course_list_page.save!

    race_list_pages = course_list_page.download_race_list_pages
    race_list_pages.each { |r| r.save! }

    # execute 1
    entry_list_page = EntryListPage.download(race_list_page, "https://www.oddspark.com/keiba/RaceList.do?raceDy=19000101&opTrackCd=01&sponsorCd=01&raceNb=1", 1, "aaa")

    # postcondition 1
    assert entry_list_page.content.length > 0
    assert entry_list_page.invalid?
    assert_equal "Invalid html", entry_list_page.errors[:url][0]
    assert_not @bucket.object("race_list/19000101/帯広競馬場/1/entry_list.html").exists?

    assert_equal 0, EntryListPage.all.length

    # execute 2
    assert_raise ActiveRecord::RecordInvalid, "Url Invalid html" do
      entry_list_page.save!
    end

    # postcondition 2
    assert_not @bucket.object("race_list/19000101/帯広競馬場/1/entry_list.html").exists?

    assert_equal 0, EntryListPage.all.length
  end

  test "parse" do
    # precondition
    course_list_page = CourseListPage.download(2018, 7, 16)
    course_list_page.save!

    race_list_pages = course_list_page.download_race_list_pages
    race_list_pages.each { |r| r.save! }

    entry_list_pages = race_list_pages[0].download_entry_list_pages

    # execute
    odds_1_page = entry_list_pages[0].download_odds_1_page
    odds_2_page = entry_list_pages[0].download_odds_2_page
    odds_3_page = entry_list_pages[0].download_odds_3_page
    odds_4_page = entry_list_pages[0].download_odds_4_page
    odds_5_page = entry_list_pages[0].download_odds_5_page
    odds_6_page = entry_list_pages[0].download_odds_6_page
    odds_7_page = entry_list_pages[0].download_odds_7_page
    result_page = entry_list_pages[0].download_result_page
    horse_page = entry_list_pages[0].download_horse_page
    jockey_page = entry_list_pages[0].download_jockey_page
    trainer_page = entry_list_pages[0].download_trainer_page

    # postcondition
    assert odds_1_page.valid?
    assert odds_2_page.valid?
    assert odds_3_page.valid?
    assert odds_4_page.valid?
    assert odds_5_page.valid?
    assert odds_6_page.valid?
    assert odds_7_page.valid?
    assert result_page.valid?
    assert horse_page.valid?
    assert jockey_page.valid?
    assert trainer_page.valid?
  end

end
