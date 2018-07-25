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
  end

  test "download entry list page: invalid html" do
    # precondition
    course_list_page = CourseListPage.download(2018, 7, 16)
    course_list_page.save!

    race_list_pages = course_list_page.download_race_list_pages
    race_list_pages.each { |r| r.save! }

    # execute 1
    entry_list_page = EntryListPage.download(race_list_pages[0], 1, "aaa", "https://www.oddspark.com/keiba/RaceList.do?raceDy=19000101&opTrackCd=01&sponsorCd=01&raceNb=1")

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
    race_list_page = RaceListPage.download(course_list_page, "aaa", "bbb", "https://www.oddspark.com/keiba/OneDayRaceList.do?raceDy=20180716&opTrackCd=03&sponsorCd=04")
    entry_list_page = EntryListPage.download(race_list_page, 1, "aaa", "https://www.oddspark.com/keiba/RaceList.do?raceDy=20180716&opTrackCd=03&sponsorCd=04&raceNb=1")

    # execute
    data = entry_list_page.parse

    # postcondition
    assert_equal "帯広:第1競走", data[:race_info][:place]
    assert_equal "ダ200m", data[:race_info][:distance]
    assert_equal "発走時間 14:45", data[:race_info][:start_time]
    assert_equal "天候", data[:race_info][:weather] # FIXME: 正しい天候を取得する
    assert_equal "1.9%", data[:race_info][:water]

    assert_equal 8, data[:horses].length

    assert_equal 1, data[:horses][0][:horse][:number]
    assert_equal "キタノショウナン", data[:horses][0][:horse][:name]
    assert_equal "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190048", data[:horses][0][:horse][:url]
    assert_equal 893, data[:horses][0][:horse][:weight]
    assert_equal -3, data[:horses][0][:horse][:weight_diff]
    assert_equal "西謙一", data[:horses][0][:jockey][:name]
    assert_equal "https://www.oddspark.com/keiba/JockeyDetail.do?jkyNb=038070", data[:horses][0][:jockey][:url]
    assert_equal "服部義", data[:horses][0][:trainer][:name]
    assert_equal "https://www.oddspark.com/keiba/TrainerDetail.do?trainerNb=018029", data[:horses][0][:trainer][:url]

    assert_equal 2, data[:horses][1][:horse][:number]
    assert_equal "ダイナユウヒメ", data[:horses][1][:horse][:name]
    assert_equal "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190060", data[:horses][1][:horse][:url]
    assert_equal 929, data[:horses][1][:horse][:weight]
    assert_equal 19, data[:horses][1][:horse][:weight_diff]
    assert_equal "松本秀", data[:horses][1][:jockey][:name]
    assert_equal "https://www.oddspark.com/keiba/JockeyDetail.do?jkyNb=038056", data[:horses][1][:jockey][:url]
    assert_equal "久田守", data[:horses][1][:trainer][:name]
    assert_equal "https://www.oddspark.com/keiba/TrainerDetail.do?trainerNb=018058", data[:horses][1][:trainer][:url]
    
    assert_equal 3, data[:horses][2][:horse][:number]
    assert_equal "カイオー", data[:horses][2][:horse][:name]
    assert_equal "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190168", data[:horses][2][:horse][:url]
    assert_equal 1000, data[:horses][2][:horse][:weight]
    assert_equal 20, data[:horses][2][:horse][:weight_diff]
    assert_equal "工藤篤", data[:horses][2][:jockey][:name]
    assert_equal "https://www.oddspark.com/keiba/JockeyDetail.do?jkyNb=038038", data[:horses][2][:jockey][:url]
    assert_equal "服部義", data[:horses][2][:trainer][:name]
    assert_equal "https://www.oddspark.com/keiba/TrainerDetail.do?trainerNb=018029", data[:horses][2][:trainer][:url]
    
    assert_equal 4, data[:horses][3][:horse][:number]
    assert_equal "ウノフクヒメ", data[:horses][3][:horse][:name]
    assert_equal "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190155", data[:horses][3][:horse][:url]
    assert_equal 873, data[:horses][3][:horse][:weight]
    assert_equal 27, data[:horses][3][:horse][:weight_diff]
    assert_equal "藤本匠", data[:horses][3][:jockey][:name]
    assert_equal "https://www.oddspark.com/keiba/JockeyDetail.do?jkyNb=038025", data[:horses][3][:jockey][:url]
    assert_equal "金田勇", data[:horses][3][:trainer][:name]
    assert_equal "https://www.oddspark.com/keiba/TrainerDetail.do?trainerNb=018069", data[:horses][3][:trainer][:url]
    
    assert_equal 5, data[:horses][4][:horse][:number]
    assert_equal "ワタシトマランサー", data[:horses][4][:horse][:name]
    assert_equal "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190119", data[:horses][4][:horse][:url]
    assert_equal 964, data[:horses][4][:horse][:weight]
    assert_equal -7, data[:horses][4][:horse][:weight_diff]
    assert_equal "藤野俊", data[:horses][4][:jockey][:name]
    assert_equal "https://www.oddspark.com/keiba/JockeyDetail.do?jkyNb=038024", data[:horses][4][:jockey][:url]
    assert_equal "鈴木邦", data[:horses][4][:trainer][:name]
    assert_equal "https://www.oddspark.com/keiba/TrainerDetail.do?trainerNb=018017", data[:horses][4][:trainer][:url]
    
    assert_equal 6, data[:horses][5][:horse][:number]
    assert_equal "ホクトペリドット", data[:horses][5][:horse][:name]
    assert_equal "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190540", data[:horses][5][:horse][:url]
    assert_equal 915, data[:horses][5][:horse][:weight]
    assert_equal -4, data[:horses][5][:horse][:weight_diff]
    assert_equal "島津新", data[:horses][5][:jockey][:name]
    assert_equal "https://www.oddspark.com/keiba/JockeyDetail.do?jkyNb=038079", data[:horses][5][:jockey][:url]
    assert_equal "岩本利", data[:horses][5][:trainer][:name]
    assert_equal "https://www.oddspark.com/keiba/TrainerDetail.do?trainerNb=018072", data[:horses][5][:trainer][:url]
    
    assert_equal 7, data[:horses][6][:horse][:number]
    assert_equal "デビットシャルマン", data[:horses][6][:horse][:name]
    assert_equal "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190920", data[:horses][6][:horse][:url]
    assert_equal 937, data[:horses][6][:horse][:weight]
    assert_equal 16, data[:horses][6][:horse][:weight_diff]
    assert_equal "村上章", data[:horses][6][:jockey][:name]
    assert_equal "https://www.oddspark.com/keiba/JockeyDetail.do?jkyNb=038047", data[:horses][6][:jockey][:url]
    assert_equal "小北栄", data[:horses][6][:trainer][:name]
    assert_equal "https://www.oddspark.com/keiba/TrainerDetail.do?trainerNb=018066", data[:horses][6][:trainer][:url]
    
    assert_equal 8, data[:horses][7][:horse][:number]
    assert_equal "テンカノサブロウ", data[:horses][7][:horse][:name]
    assert_equal "https://www.oddspark.com/keiba/HorseDetail.do?lineageNb=2270190906", data[:horses][7][:horse][:url]
    assert_equal 925, data[:horses][7][:horse][:weight]
    assert_equal -6, data[:horses][7][:horse][:weight_diff]
    assert_equal "長澤幸", data[:horses][7][:jockey][:name]
    assert_equal "https://www.oddspark.com/keiba/JockeyDetail.do?jkyNb=038074", data[:horses][7][:jockey][:url]
    assert_equal "服部義", data[:horses][7][:trainer][:name]
    assert_equal "https://www.oddspark.com/keiba/TrainerDetail.do?trainerNb=018029", data[:horses][7][:trainer][:url]

    assert_equal "https://www.oddspark.com/keiba/Odds.do?sponsorCd=04&raceDy=20180716&opTrackCd=03&raceNb=1", data[:odds][:url]

    assert_equal "https://www.oddspark.com/keiba/RaceResult.do?sponsorCd=04&raceDy=20180716&opTrackCd=03&raceNb=1", data[:result][:url]
  end

  test "save, and overwrite" do
    # precondition
    course_list_page = CourseListPage.download(2018, 7, 16)
    course_list_page.save!

    race_list_page = RaceListPage.download(course_list_page, "aaa", "bbb", "https://www.oddspark.com/keiba/OneDayRaceList.do?raceDy=20180716&opTrackCd=03&sponsorCd=04")
    race_list_page.save!

    # execute 1
    entry_list_page = EntryListPage.download(race_list_page, 1, "aaa", "https://www.oddspark.com/keiba/RaceList.do?raceDy=20180716&opTrackCd=03&sponsorCd=04&raceNb=1")

    # postcondition 1
    assert entry_list_page.valid?

    assert_equal 0, EntryListPage.all.length

    # execute 2
    entry_list_page.save!

    # postcondition 2
    assert_equal 1, EntryListPage.all.length

    # execute 3
    entry_list_page_2 = EntryListPage.download(race_list_page, 1, "aaa", "https://www.oddspark.com/keiba/RaceList.do?raceDy=20180716&opTrackCd=03&sponsorCd=04&raceNb=1")

    # postcondition 3
    assert_equal 1, EntryListPage.all.length
    assert_equal 1, race_list_page.entry_list_pages.length

    race_list_page.entry_list_pages.each do |entry_list_page_db|
      assert entry_list_page_2.same?(entry_list_page_db)
    end

    # execute 4
    entry_list_page_2.save!

    # postcondition 4
    assert_equal 1, EntryListPage.all.length
  end

  test "find all" do
    # precondition
    course_list_page = CourseListPage.download(2018, 7, 16)
    course_list_page.save!

    race_list_page = RaceListPage.download(course_list_page, "aaa", "bbb", "https://www.oddspark.com/keiba/OneDayRaceList.do?raceDy=20180716&opTrackCd=03&sponsorCd=04")
    race_list_page.save!

    entry_list_pages = race_list_page.download_entry_list_pages
    entry_list_pages.each { |e| e.save! }

    # execute
    entry_list_pages_db = race_list_page.entry_list_pages

    # postcondition
    assert_equal 11, EntryListPage.all.length

    assert_equal entry_list_pages.length, entry_list_pages_db.length

    entry_list_pages.each do |entry_list_page|
      entry_list_page_db = entry_list_pages_db.find { |e| e.url == entry_list_page.url }

      assert entry_list_page.same?(entry_list_page_db)
    end
  end

end
