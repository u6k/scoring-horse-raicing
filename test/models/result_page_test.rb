require 'test_helper'

class ResultPageTest < ActiveSupport::TestCase

  def setup
    @bucket = NetModule.get_s3_bucket
    @bucket.objects.batch_delete!
  end

  test "download" do
    # precondition
    schedule_page_html = File.open("test/fixtures/files/schedule.201806.html").read
    schedule_page = SchedulePage.download(2018, 6, schedule_page_html)

    race_list_page_html = File.open("test/fixtures/files/race_list.20180603.tokyo.html").read
    race_list_page = RaceListPage.download(schedule_page, "https://keiba.yahoo.co.jp/race/list/18050301/", Time.zone.local(2018, 6, 3), "東京", race_list_page_html)

    # execute
    result_pages = race_list_page.download_result_pages

    # postcondition
    assert_equal 0, ResultPage.all.length

    assert_equal 12, result_pages.length

    result_page = result_pages[0]
    assert_equal "https://keiba.yahoo.co.jp/race/result/1805030201/", result_page.url
    assert_equal 1, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 3, 10, 5, 0), result_page.start_datetime
    assert_equal "サラ系3歳未勝利", result_page.race_name
    assert result_page.race_list_page.same?(race_list_page)
    assert result_page.content.length > 0
    assert result_page.valid?
    assert_not @bucket.object("html/201806/20180602/東京/1/result.html").exists?

    result_page = result_pages[1]
    assert_equal "https://keiba.yahoo.co.jp/race/result/1805030202/", result_page.url
    assert_equal 2, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 3, 10, 35, 0), result_page.start_datetime
    assert_equal "サラ系3歳未勝利", result_page.race_name
    assert result_page.race_list_page.same?(race_list_page)
    assert result_page.content.length > 0
    assert result_page.valid?
    assert_not @bucket.object("html/201806/20180602/東京/2/result.html").exists?

    result_page = result_pages[2]
    assert_equal "https://keiba.yahoo.co.jp/race/result/1805030203/", result_page.url
    assert_equal 3, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 3, 11, 05, 0), result_page.start_datetime
    assert_equal "サラ系3歳未勝利", result_page.race_name
    assert result_page.race_list_page.same?(race_list_page)
    assert result_page.content.length > 0
    assert result_page.valid?
    assert_not @bucket.object("html/201806/20180602/東京/3/result.html").exists?

    result_page = result_pages[3]
    assert_equal "https://keiba.yahoo.co.jp/race/result/1805030204/", result_page.url
    assert_equal 4, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 3, 11, 35, 0), result_page.start_datetime
    assert_equal "サラ系3歳未勝利", result_page.race_name
    assert result_page.race_list_page.same?(race_list_page)
    assert result_page.content.length > 0
    assert result_page.valid?
    assert_not @bucket.object("html/201806/20180602/東京/4/result.html").exists?

    result_page = result_pages[4]
    assert_equal "https://keiba.yahoo.co.jp/race/result/1805030205/", result_page.url
    assert_equal 5, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 3, 12, 25, 0), result_page.start_datetime
    assert_equal "サラ系2歳新馬", result_page.race_name
    assert result_page.race_list_page.same?(race_list_page)
    assert result_page.content.length > 0
    assert result_page.valid?
    assert_not @bucket.object("html/201806/20180602/東京/5/result.html").exists?

    result_page = result_pages[5]
    assert_equal "https://keiba.yahoo.co.jp/race/result/1805030206/", result_page.url
    assert_equal 6, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 3, 12, 55, 0), result_page.start_datetime
    assert_equal "サラ系2歳新馬", result_page.race_name
    assert result_page.race_list_page.same?(race_list_page)
    assert result_page.content.length > 0
    assert result_page.valid?
    assert_not @bucket.object("html/201806/20180602/東京/6/result.html").exists?

    result_page = result_pages[6]
    assert_equal "https://keiba.yahoo.co.jp/race/result/1805030207/", result_page.url
    assert_equal 7, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 3, 13, 25, 0), result_page.start_datetime
    assert_equal "サラ系3歳上500万円以下", result_page.race_name
    assert result_page.race_list_page.same?(race_list_page)
    assert result_page.content.length > 0
    assert result_page.valid?
    assert_not @bucket.object("html/201806/20180602/東京/7/result.html").exists?

    result_page = result_pages[7]
    assert_equal "https://keiba.yahoo.co.jp/race/result/1805030208/", result_page.url
    assert_equal 8, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 3, 13, 55, 0), result_page.start_datetime
    assert_equal "サラ系3歳上500万円以下", result_page.race_name
    assert result_page.race_list_page.same?(race_list_page)
    assert result_page.content.length > 0
    assert result_page.valid?
    assert_not @bucket.object("html/201806/20180602/東京/8/result.html").exists?

    result_page = result_pages[8]
    assert_equal "https://keiba.yahoo.co.jp/race/result/1805030209/", result_page.url
    assert_equal 9, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 3, 14, 25, 0), result_page.start_datetime
    assert_equal "ホンコンジョッキークラブトロフィー", result_page.race_name
    assert result_page.race_list_page.same?(race_list_page)
    assert result_page.content.length > 0
    assert result_page.valid?
    assert_not @bucket.object("html/201806/20180602/東京/9/result.html").exists?

    result_page = result_pages[9]
    assert_equal "https://keiba.yahoo.co.jp/race/result/1805030210/", result_page.url
    assert_equal 10, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 3, 15, 01, 0), result_page.start_datetime
    assert_equal "由比ヶ浜特別", result_page.race_name
    assert result_page.race_list_page.same?(race_list_page)
    assert result_page.content.length > 0
    assert result_page.valid?
    assert_not @bucket.object("html/201806/20180602/東京/10/result.html").exists?

    result_page = result_pages[10]
    assert_equal "https://keiba.yahoo.co.jp/race/result/1805030211/", result_page.url
    assert_equal 11, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 3, 15, 40, 0), result_page.start_datetime
    assert_equal "安田記念（GI）", result_page.race_name
    assert result_page.race_list_page.same?(race_list_page)
    assert result_page.content.length > 0
    assert result_page.valid?
    assert_not @bucket.object("html/201806/20180602/東京/11/result.html").exists?

    result_page = result_pages[11]
    assert_equal "https://keiba.yahoo.co.jp/race/result/1805030212/", result_page.url
    assert_equal 12, result_page.race_number
    assert_equal Time.zone.local(2018, 6, 3, 16, 25, 0), result_page.start_datetime
    assert_equal "三浦特別", result_page.race_name
    assert result_page.race_list_page.same?(race_list_page)
    assert result_page.content.length > 0
    assert result_page.valid?
    assert_not @bucket.object("html/201806/20180602/東京/12/result.html").exists?
  end

  test "download: case invalid html" do
    # precondition
    schedule_page_html = File.open("test/fixtures/files/schedule.201806.html").read
    schedule_page = SchedulePage.download(2018, 6, schedule_page_html)

    race_list_page = RaceListPage.download(schedule_page, "https://keiba.yahoo.co.jp/race/list/18050301/", Time.zone.local(2018, 6, 3), "東京", "Invalid html")

    # execute
    result_pages = race_list_page.download_result_pages

    # postcondition
    assert_equal 0, ResultPage.all.length

    assert_nil result_pages
  end

  test "parse" do
    # precondition
    schedule_page_html = File.open("test/fixtures/files/schedule.201806.html").read
    schedule_page = SchedulePage.download(2018, 6, schedule_page_html)

    race_list_page_html = File.open("test/fixtures/files/race_list.20180603.tokyo.html").read
    race_list_page = RaceListPage.download(schedule_page, "https://keiba.yahoo.co.jp/race/list/18050301/", Time.zone.local(2018, 6, 3), "東京", race_list_page_html)

    result_page_html = File.open("test/fixtures/files/result.20180624.tokyo.10.html").read
    result_page = ResultPage.download(race_list_page, "https://keiba.yahoo.co.jp/race/list/18050308/", 10, Time.zone.local(2018, 6, 24, 14, 50, 0), "清里特別", result_page_html)

    # execute
    page_data = result_page.parse

    # postcondition
    expected_data = {
      menu: {
        entries: "https://keiba.yahoo.co.jp/race/denma/1805030810/",
        odds_win: "https://keiba.yahoo.co.jp/odds/tfw/1805030810/",
      },
      result: [
        {
          order_of_finish: 1,
          bracket_number: 2,
          horse_number: 3,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/2015104347/",
          horse_name: "ルッジェーロ",
          finish_time: 82.7
        },
        {
          order_of_finish: 2,
          bracket_number: 5,
          horse_number: 9,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/2013109018/",
          horse_name: "リスペクトアース",
          finish_time: 82.7
        },
        {
          order_of_finish: 3,
          bracket_number: 1,
          horse_number: 2,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/2015110066/",
          horse_name: "ジャスパーウィン",
          finish_time: 82.7
        },
        {
          order_of_finish: 4,
          bracket_number: 4,
          horse_number: 7,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/2014103001/",
          horse_name: "メイショウサチシオ",
          finish_time: 82.8
        },
        {
          order_of_finish: 5,
          bracket_number: 2,
          horse_number: 4,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/2012103491/",
          horse_name: "ダイワスキャンプ",
          finish_time: 82.8
        },
        {
          order_of_finish: 6,
          bracket_number: 8,
          horse_number: 16,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/2014102262/",
          horse_name: "ミスパイロ",
          finish_time: 83.2
        },
        {
          order_of_finish: 7,
          bracket_number: 3,
          horse_number: 6,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/2014106109/",
          horse_name: "ワシントンレガシー",
          finish_time: 83.3
        },
        {
          order_of_finish: 8,
          bracket_number: 6,
          horse_number: 11,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/2013105547/",
          horse_name: "アオイサンシャイン",
          finish_time: 83.3
        },
        {
          order_of_finish: 9,
          bracket_number: 5,
          horse_number: 10,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/2012105841/",
          horse_name: "ティアップサンダー",
          finish_time: 83.3
        },
        {
          order_of_finish: 10,
          bracket_number: 1,
          horse_number: 1,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/2013103294/",
          horse_name: "ララパルーザ",
          finish_time: 83.4
        },
        {
          order_of_finish: 11,
          bracket_number: 7,
          horse_number: 14,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/2013103352/",
          horse_name: "ノーブルサンズ",
          finish_time: 83.7
        },
        {
          order_of_finish: 12,
          bracket_number: 4,
          horse_number: 8,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/2014104021/",
          horse_name: "ワンダープラヤアン",
          finish_time: 83.8
        },
        {
          order_of_finish: 13,
          bracket_number: 3,
          horse_number: 5,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/2015105066/",
          horse_name: "レピアーウィット",
          finish_time: 83.9
        },
        {
          order_of_finish: 14,
          bracket_number: 8,
          horse_number: 15,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/2015102713/",
          horse_name: "ザイオン",
          finish_time: 84.1
        },
        {
          order_of_finish: 15,
          bracket_number: 6,
          horse_number: 12,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/2012105220/",
          horse_name: "ペプチドアルマ",
          finish_time: 84.1
        },
        {
          order_of_finish: 16,
          bracket_number: 7,
          horse_number: 13,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/2014100530/",
          horse_name: "ヤマトワイルド",
          finish_time: 85.3
        }
      ]
    }

    assert_equal page_data, expected_data
  end

  test "parse: case retire" do
    # precondition
    schedule_page_html = File.open("test/fixtures/files/schedule.201806.html").read
    schedule_page = SchedulePage.download(2018, 6, schedule_page_html)

    race_list_page_html = File.open("test/fixtures/files/race_list.20180603.tokyo.html").read
    race_list_page = RaceListPage.download(schedule_page, "https://keiba.yahoo.co.jp/race/list/18050301/", Time.zone.local(2018, 6, 3), "東京", race_list_page_html)

    result_page_html = File.open("test/fixtures/files/result.19860126.tyukyou.11.html").read
    result_page = ResultPage.download(race_list_page, "https://www.example.com/result.19860126.tyukyou.11.html", 11, Time.zone.local(1986, 1, 26, 15, 35, 0), "中京スポーツ杯", result_page_html)

    # execute
    page_data = result_page.parse

    # postcondition
    expected_data = {
      menu: {
      },
      result: [
        {
          order_of_finish: 1,
          bracket_number: 5,
          horse_number: 9,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/1981105030/",
          horse_name: "ハクリョウベル",
          finish_time: 109.8
        },
        {
          order_of_finish: 2,
          bracket_number: 4,
          horse_number: 8,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/1982101926/",
          horse_name: "ルオースポート",
          finish_time: 109.8
        },
        {
          order_of_finish: 3,
          bracket_number: 6,
          horse_number: 12,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/1980102195/",
          horse_name: "メジロレマノ",
          finish_time: 110.1
        },
        {
          order_of_finish: 4,
          bracket_number: 7,
          horse_number: 14,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/1981105305/",
          horse_name: "オサイチセンプー",
          finish_time: 110.2
        },
        {
          order_of_finish: 5,
          bracket_number: 3,
          horse_number: 5,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/1980106560/",
          horse_name: "レインボーピット",
          finish_time: 110.3
        },
        {
          order_of_finish: 6,
          bracket_number: 1,
          horse_number: 2,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/1981103008/",
          horse_name: "ニットウタチバナ",
          finish_time: 110.3
        },
        {
          order_of_finish: 7,
          bracket_number: 4,
          horse_number: 7,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/1980100417/",
          horse_name: "テイダイ",
          finish_time: 110.4
        },
        {
          order_of_finish: 8,
          bracket_number: 2,
          horse_number: 3,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/1982104865/",
          horse_name: "ファイブニッポン",
          finish_time: 110.5
        },
        {
          order_of_finish: 9,
          bracket_number: 2,
          horse_number: 4,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/1981102714/",
          horse_name: "ミスタースナーク",
          finish_time: 110.6
        },
        {
          order_of_finish: 10,
          bracket_number: 6,
          horse_number: 11,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/1982101034/",
          horse_name: "トーアタイヘイ",
          finish_time: 110.6
        },
        {
          order_of_finish: 11,
          bracket_number: 7,
          horse_number: 13,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/1980102046/",
          horse_name: "アイリスクイン",
          finish_time: 110.8
        },
        {
          order_of_finish: 12,
          bracket_number: 3,
          horse_number: 6,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/1981105157/",
          horse_name: "エリザベートアイ",
          finish_time: 111.0
        },
        {
          order_of_finish: 13,
          bracket_number: 1,
          horse_number: 1,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/1982107263/",
          horse_name: "コレハル",
          finish_time: 111.3
        },
        {
          order_of_finish: 14,
          bracket_number: 8,
          horse_number: 16,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/1982101932/",
          horse_name: "ダイナソレイユ",
          finish_time: 111.3
        },
        {
          order_of_finish: 15,
          bracket_number: 5,
          horse_number: 10,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/1982106904/",
          horse_name: "ヘイアンスイート",
          finish_time: 112.0
        },
        {
          bracket_number: 8,
          horse_number: 15,
          horse_url: "https://keiba.yahoo.co.jp/directory/horse/1980102147/",
          horse_name: "ドクターゴールド",
        }
      ]
    }

    assert_equal page_data, expected_data
  end

  test "parse: case invalid html" do
    # precondition
    schedule_page = SchedulePage.download(2018, 6, "Invalid html")

    race_list_page = RaceListPage.download(schedule_page, "https://keiba.yahoo.co.jp/race/list/18050301/", Time.zone.local(2018, 6, 3), "東京", "Invalid html")

    result_page = ResultPage.download(race_list_page, "https://www.example.com/result.19860126.tyukyou.11.html", 11, Time.zone.local(1986, 1, 26, 15, 35, 0), "中京スポーツ杯", "Invalid html")

    # execute
    page_data = result_page.parse

    # postcondition
    assert_nil page_data
  end
    
end
