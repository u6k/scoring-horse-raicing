require "timecop"
require "webmock/rspec"

require "spec_helper"

RSpec.describe InvestmentHorseRacing::Crawler::Parser::EntryPageParser do
  before do
    WebMock.enable!

    @downloader = Crawline::Downloader.new("investment-horse-racing-crawler/#{InvestmentHorseRacing::Crawler::VERSION}")

    # Setup data
    InvestmentHorseRacing::Crawler::Model::RaceMeta.destroy_all

    ## 2018-06-24 hanshin no 1 race result data
    url = "https://keiba.yahoo.co.jp/race/result/1809030801/"
    WebMock.stub_request(:get, url).to_return(
      status: [200, "OK"],
      body: File.open("spec/data/result.20180624.hanshin.1.html").read)

    parser = InvestmentHorseRacing::Crawler::Parser::ResultPageParser.new(url, @downloader.download_with_get(url))
    parser.parse({})

    @meta = InvestmentHorseRacing::Crawler::Model::RaceMeta.find_by(race_id: "1809030801")

    ## 2018-06-24 hanshin no 11 race result data
    url = "https://keiba.yahoo.co.jp/race/result/1809030811/"
    WebMock.stub_request(:get, url).to_return(
      status: [200, "OK"],
      body: File.open("spec/data/result.20180624.hanshin.11.html").read)

    parser = InvestmentHorseRacing::Crawler::Parser::ResultPageParser.new(url, @downloader.download_with_get(url))
    parser.parse({})

    @meta_11 = InvestmentHorseRacing::Crawler::Model::RaceMeta.find_by(race_id: "1809030811")

    ## 2019-04-06 fukushima no 11 race result data
    url = "https://keiba.yahoo.co.jp/race/result/1903010111/"
    WebMock.stub_request(:get, url).to_return(
      status: [200, "OK"],
      body: File.open("spec/data/result.20190406.fukushima.11.html").read)

    parser = InvestmentHorseRacing::Crawler::Parser::ResultPageParser.new(url, @downloader.download_with_get(url))
    parser.parse({})

    @meta_20190406 = InvestmentHorseRacing::Crawler::Model::RaceMeta.find_by(race_id: "1903010111")

    ## error race meta data
    InvestmentHorseRacing::Crawler::Model::RaceMeta.create(race_id: "0000000000")

    # Setup parser
    ## 2018-06-24 hanshin no 1 race entry page parser
    @url = "https://keiba.yahoo.co.jp/race/denma/1809030801/"
    WebMock.stub_request(:get, @url).to_return(
      status: [200, "OK"],
      body: File.open("spec/data/entry.20180624.hanshin.1.html").read)

    @parser = InvestmentHorseRacing::Crawler::Parser::EntryPageParser.new(@url, @downloader.download_with_get(@url))

    ## 2018-06-24 hanshin no 11 race entry page parser
    @url_11 = "https://keiba.yahoo.co.jp/race/denma/1809030811/"
    WebMock.stub_request(:get, @url_11).to_return(
      status: [200, "OK"],
      body: File.open("spec/data/entry.20180624.hanshin.11.html").read)

    @parser_11 = InvestmentHorseRacing::Crawler::Parser::EntryPageParser.new(@url_11, @downloader.download_with_get(@url_11))

    ## 2019-04-06 fukushima no 11 race entry page parser
    @url_20190406 = "https://keiba.yahoo.co.jp/race/denma/1903010111/"
    WebMock.stub_request(:get, @url_20190406).to_return(
      status: [200, "OK"],
      body: File.open("spec/data/entry.20190406.fukushima.11.html").read)

    @parser_20190406 = InvestmentHorseRacing::Crawler::Parser::EntryPageParser.new(@url_20190406, @downloader.download_with_get(@url_20190406))

    ## error page parser
    url = "https://keiba.yahoo.co.jp/race/denma/0000000000/"
    WebMock.stub_request(:get, url).to_return(
      status: [200, "OK"],
      body: File.open("spec/data/entry.0000000000.error.html").read)

    @parser_error = InvestmentHorseRacing::Crawler::Parser::EntryPageParser.new(url, @downloader.download_with_get(url))

    WebMock.disable!
  end

  describe "#redownload?" do
    context "2018-06-24 hanshin no 1 race entry page" do
      it "redownload if newer than 30 days" do
        Timecop.freeze(Time.local(2018, 7, 24, 10, 4, 0)) do
          expect(@parser).to be_redownload
        end
      end

      it "do not redownload if over 30 days old" do
        Timecop.freeze(Time.local(2018, 7, 24, 10, 5, 0)) do
          expect(@parser).not_to be_redownload
        end
      end
    end
  end

  describe "#related_links" do
    context "2018-06-24 hanshin no 1 race entry page" do
      it "is horse, jocky, trainer pages" do
        expect(@parser.related_links).to be_nil
      end
    end

    context "2018-06-24 hanshin no 11 race entry page" do
      it "is horse, jockey, trainer pages" do
        expect(@parser_11.related_links).to be_nil
      end
    end
  end

  describe "#parse" do
    context "2018-06-24 hanshin no 1 race entry page" do
      it "is entry info" do
        context = {}

        @parser.parse(context)

        expect(context).to be_empty

        expected = build_expected

        expect(InvestmentHorseRacing::Crawler::Model::RaceEntry.all).to match_array(expected)
      end
    end

    context "2018-06-24 hanshin no 11 race entry page" do
      it "is entry info" do
        context = {}

        @parser_11.parse(context)

        expect(context).to be_empty

        expected = build_expected_11

        expect(InvestmentHorseRacing::Crawler::Model::RaceEntry.all).to match_array(expected)
      end
    end

    context "2019-04-06 fukushima no 11 race entry page" do
      it "is entry info" do
        context = {}

        @parser_20190406.parse(context)

        expect(context).to be_empty

        expect({}).to be_empty

        expected = build_expected_20190406

        expect(InvestmentHorseRacing::Crawler::Model::RaceEntry.all).to match_array(expected)
      end
    end

    context "existing data" do
      before do
        @meta_11111 = InvestmentHorseRacing::Crawler::Model::RaceMeta.create(race_id: "11111")
        @meta_22222 = InvestmentHorseRacing::Crawler::Model::RaceMeta.create(race_id: "22222")

        InvestmentHorseRacing::Crawler::Model::RaceEntry.create(race_meta: @meta_11, horse_id: "11111")
        InvestmentHorseRacing::Crawler::Model::RaceEntry.create(race_meta: @meta_11, horse_id: "22222")
        InvestmentHorseRacing::Crawler::Model::RaceEntry.create(race_meta: @meta_11, horse_id: "33333")

        InvestmentHorseRacing::Crawler::Model::RaceEntry.create(race_meta: @meta_11111, horse_id: "11111-11111")
        InvestmentHorseRacing::Crawler::Model::RaceEntry.create(race_meta: @meta_11111, horse_id: "11111-22222")
        InvestmentHorseRacing::Crawler::Model::RaceEntry.create(race_meta: @meta_11111, horse_id: "11111-33333")

        InvestmentHorseRacing::Crawler::Model::RaceEntry.create(race_meta: @meta_22222, horse_id: "22222-11111")
        InvestmentHorseRacing::Crawler::Model::RaceEntry.create(race_meta: @meta_22222, horse_id: "22222-22222")
        InvestmentHorseRacing::Crawler::Model::RaceEntry.create(race_meta: @meta_22222, horse_id: "22222-33333")
      end

      it "is entry info" do
        context = {}

        @parser_11.parse(context)

        expect(context).to be_empty

        expected = build_expected_11
        expected << have_attributes(race_meta_id: @meta_11111.id, horse_id: "11111-11111")
        expected << have_attributes(race_meta_id: @meta_11111.id, horse_id: "11111-22222")
        expected << have_attributes(race_meta_id: @meta_11111.id, horse_id: "11111-33333")
        expected << have_attributes(race_meta_id: @meta_22222.id, horse_id: "22222-11111")
        expected << have_attributes(race_meta_id: @meta_22222.id, horse_id: "22222-22222")
        expected << have_attributes(race_meta_id: @meta_22222.id, horse_id: "22222-33333")

        expect(InvestmentHorseRacing::Crawler::Model::RaceEntry.all).to match_array(expected)
      end
    end

    context "race meta not found" do
      before do
        InvestmentHorseRacing::Crawler::Model::RaceMeta.destroy_all
      end

      it "raised" do
        url = "https://keiba.yahoo.co.jp/race/denma/1809030801/"
        data = {
          "url" => "https://keiba.yahoo.co.jp/race/denma/1809030801/",
          "request_method" => "GET",
          "request_headers" => {},
          "response_headers" => {},
          "response_body" => File.open("spec/data/entry.20180624.hanshin.1.html").read,
          "downloaded_timestamp" => Time.utc(2018, 6, 24, 0, 0, 0)}

        expect { InvestmentHorseRacing::Crawler::Parser::EntryPageParser.new(url, data) }.to raise_error "RaceMeta(race_id: 1809030801) not found."
      end
    end

    context "valid page on web" do
      it "parse success" do
        parser = InvestmentHorseRacing::Crawler::Parser::EntryPageParser.new(@url, @downloader.download_with_get(@url))
        parser.parse({})

        expect(InvestmentHorseRacing::Crawler::Model::RaceEntry.all.count).to be > 0
      end
    end

    def build_expected
      [
        have_attributes(
          race_meta_id: @meta.id,
          bracket_number: 1,
          horse_number: 1,
          horse_id: "2015104308",
          horse_name: "プロネルクール",
          gender: "牝",
          age: 3,
          coat_color: "鹿毛",
          trainer_id: "01120",
          trainer_name: "千田 輝彦",
          horse_weight: 482,
          jockey_id: "05339",
          jockey_name: "C.ルメール",
          jockey_weight: 54.0,
          father_horse_name: "ゴールドアリュール",
          mother_horse_name: "グラッブユアハート"
        ),
        have_attributes(
          race_meta_id: @meta.id,
          bracket_number: 1,
          horse_number: 2,
          horse_id: "2015104964",
          horse_name: "スーブレット",
          gender: "牝",
          age: 3,
          coat_color: "栗毛",
          trainer_id: "01022",
          trainer_name: "石坂 正",
          horse_weight: 470,
          jockey_id: "01014",
          jockey_name: "福永 祐一",
          jockey_weight: 54.0,
          father_horse_name: "ゴールドアリュール",
          mother_horse_name: "フラーテイシャスミス"
        ),
        have_attributes(
          race_meta_id: @meta.id,
          bracket_number: 2,
          horse_number: 3,
          horse_id: "2015100632",
          horse_name: "アデル",
          gender: "牝",
          age: 3,
          coat_color: "鹿毛",
          trainer_id: "01046",
          trainer_name: "鮫島 一歩",
          horse_weight: 452,
          jockey_id: "01088",
          jockey_name: "川田 将雅",
          jockey_weight: 54.0,
          father_horse_name: "オルフェーヴル",
          mother_horse_name: "ラフアウェイ"
        ),
        have_attributes(
          race_meta_id: @meta.id,
          bracket_number: 2,
          horse_number: 4,
          horse_id: "2015100586",
          horse_name: "ヤマニンフィオッコ",
          gender: "牝",
          age: 3,
          coat_color: "栗毛",
          trainer_id: "01140",
          trainer_name: "石橋 守",
          horse_weight: 452,
          jockey_id: "01114",
          jockey_name: "田中 健",
          jockey_weight: 54.0,
          father_horse_name: "ヨハネスブルグ",
          mother_horse_name: "ヤマニンプロローグ"
        ),
        have_attributes(
          race_meta_id: @meta.id,
          bracket_number: 3,
          horse_number: 5,
          horse_id: "2015103335",
          horse_name: "メイショウハニー",
          gender: "牝",
          age: 3,
          coat_color: "黒鹿毛",
          trainer_id: "01041",
          trainer_name: "藤沢 則雄",
          horse_weight: 418,
          jockey_id: "01165",
          jockey_name: "森 裕太朗",
          jockey_weight: 52.0,
          father_horse_name: "ネオユニヴァース",
          mother_horse_name: "ピエナマーメイド"
        ),
        have_attributes(
          race_meta_id: @meta.id,
          bracket_number: 3,
          horse_number: 6,
          horse_id: "2015104928",
          horse_name: "レンブランサ",
          gender: "牝",
          age: 3,
          coat_color: "栗毛",
          trainer_id: "01073",
          trainer_name: "宮本 博",
          horse_weight: 436,
          jockey_id: "00894",
          jockey_name: "小牧 太",
          jockey_weight: 54.0,
          father_horse_name: "ヘニーヒューズ",
          mother_horse_name: "パシオンルージュ"
        ),
        have_attributes(
          race_meta_id: @meta.id,
          bracket_number: 4,
          horse_number: 7,
          horse_id: "2015106259",
          horse_name: "アンジェレッタ",
          gender: "牝",
          age: 3,
          coat_color: "鹿毛",
          trainer_id: "01078",
          trainer_name: "北出 成人",
          horse_weight: 468,
          jockey_id: "01034",
          jockey_name: "酒井 学",
          jockey_weight: 54.0,
          father_horse_name: "ロードカナロア",
          mother_horse_name: "セクシーココナッツ"
        ),
        have_attributes(
          race_meta_id: @meta.id,
          bracket_number: 4,
          horse_number: 8,
          horse_id: "2015102694",
          horse_name: "テーオーパートナー",
          gender: "牝",
          age: 3,
          coat_color: "栗毛",
          trainer_id: "01104",
          trainer_name: "笹田 和秀",
          horse_weight: 466,
          jockey_id: "05203",
          jockey_name: "岩田 康誠",
          jockey_weight: 54.0,
          father_horse_name: "ヘニーヒューズ",
          mother_horse_name: "ミスアイーカメ"
        ),
        have_attributes(
          race_meta_id: @meta.id,
          bracket_number: 5,
          horse_number: 9,
          horse_id: "2015102837",
          horse_name: "ウインタイムリープ",
          gender: "牝",
          age: 3,
          coat_color: "鹿毛",
          trainer_id: "01050",
          trainer_name: "飯田 雄三",
          horse_weight: 448,
          jockey_id: "01126",
          jockey_name: "松山 弘平",
          jockey_weight: 54.0,
          father_horse_name: "スズカマンボ",
          mother_horse_name: "タイムヒロイン"
        ),
        have_attributes(
          race_meta_id: @meta.id,
          bracket_number: 5,
          horse_number: 10,
          horse_id: "2015105363",
          horse_name: "モリノマリン",
          gender: "牝",
          age: 3,
          coat_color: "鹿毛",
          trainer_id: "01138",
          trainer_name: "浜田 多実雄",
          horse_weight: 442,
          jockey_id: "01019",
          jockey_name: "秋山 真一郎",
          jockey_weight: 54.0,
          father_horse_name: "ヘニーヒューズ",
          mother_horse_name: "ヤマイチシキブ"
        ),
        have_attributes(
          race_meta_id: @meta.id,
          bracket_number: 6,
          horse_number: 11,
          horse_id: "2015101618",
          horse_name: "プロムクイーン",
          gender: "牝",
          age: 3,
          coat_color: "鹿毛",
          trainer_id: "01066",
          trainer_name: "岡田 稲男",
          horse_weight: 464,
          jockey_id: "01166",
          jockey_name: "川又 賢治",
          jockey_weight: 52.0,
          father_horse_name: "キングズベスト",
          mother_horse_name: "ステージスクール"
        ),
        have_attributes(
          race_meta_id: @meta.id,
          bracket_number: 6,
          horse_number: 12,
          horse_id: "2015102853",
          horse_name: "ナイスドゥ",
          gender: "牝",
          age: 3,
          coat_color: "栗毛",
          trainer_id: "01111",
          trainer_name: "鈴木 孝志",
          horse_weight: 438,
          jockey_id: "01018",
          jockey_name: "和田 竜二",
          jockey_weight: 54.0,
          father_horse_name: "フサイチセブン",
          mother_horse_name: "ナイスヴァレー"
        ),
        have_attributes(
          race_meta_id: @meta.id,
          bracket_number: 7,
          horse_number: 13,
          horse_id: "2015103462",
          horse_name: "アクアレーヌ",
          gender: "牝",
          age: 3,
          coat_color: "鹿毛",
          trainer_id: "00356",
          trainer_name: "坂口 正則",
          horse_weight: 460,
          jockey_id: "01130",
          jockey_name: "高倉 稜",
          jockey_weight: 54.0,
          father_horse_name: "エイシンフラッシュ",
          mother_horse_name: "エンジェルダンス"
        ),
        have_attributes(
          race_meta_id: @meta.id,
          bracket_number: 7,
          horse_number: 14,
          horse_id: "2015103590",
          horse_name: "モンテルース",
          gender: "牝",
          age: 3,
          coat_color: "黒鹿毛",
          trainer_id: "01157",
          trainer_name: "杉山 晴紀",
          horse_weight: 472,
          jockey_id: "05386",
          jockey_name: "戸崎 圭太",
          jockey_weight: 54.0,
          father_horse_name: "アグネスデジタル",
          mother_horse_name: "クリスティビーム"
        ),
        have_attributes(
          race_meta_id: @meta.id,
          bracket_number: 8,
          horse_number: 15,
          horse_id: "2015104979",
          horse_name: "リーズン",
          gender: "牝",
          age: 3,
          coat_color: "鹿毛",
          trainer_id: "00438",
          trainer_name: "安田 隆行",
          horse_weight: 446,
          jockey_id: "01116",
          jockey_name: "藤岡 康太",
          jockey_weight: 54.0,
          father_horse_name: "ロードカナロア",
          mother_horse_name: "プリームス"
        ),
        have_attributes(
          race_meta_id: @meta.id,
          bracket_number: 8,
          horse_number: 16,
          horse_id: "2015103557",
          horse_name: "スマートスピカ",
          gender: "牝",
          age: 3,
          coat_color: "鹿毛",
          trainer_id: "01022",
          trainer_name: "石坂 正",
          horse_weight: 418,
          jockey_id: "01154",
          jockey_name: "松若 風馬",
          jockey_weight: 54.0,
          father_horse_name: "キングカメハメハ",
          mother_horse_name: "ショウナンガッド"
        ),
      ]
    end

    def build_expected_11
      [
        have_attributes(
          race_meta_id: @meta_11.id,
          bracket_number: 1,
          horse_number: 1,
          horse_id: "2011103854",
          horse_name: "ステファノス",
          gender: "牡",
          age: 7,
          coat_color: "鹿毛",
          trainer_id: "01055",
          trainer_name: "藤原 英昭",
          horse_weight: 486,
          jockey_id: "05203",
          jockey_name: "岩田 康誠",
          jockey_weight: 58.0,
          father_horse_name: "ディープインパクト",
          mother_horse_name: "ココシュニック"
        ),
        have_attributes(
          race_meta_id: @meta_11.id,
          bracket_number: 1,
          horse_number: 2,
          horse_id: "2013102360",
          horse_name: "ノーブルマーズ",
          gender: "牡",
          age: 5,
          coat_color: "栗毛",
          trainer_id: "01073",
          trainer_name: "宮本 博",
          horse_weight: 490,
          jockey_id: "01130",
          jockey_name: "高倉 稜",
          jockey_weight: 58.0,
          father_horse_name: "ジャングルポケット",
          mother_horse_name: "アイアンドユー"
        ),
        have_attributes(
          race_meta_id: @meta_11.id,
          bracket_number: 2,
          horse_number: 3,
          horse_id: "2013106101",
          horse_name: "サトノダイヤモンド",
          gender: "牡",
          age: 5,
          coat_color: "鹿毛",
          trainer_id: "01071",
          trainer_name: "池江 泰寿",
          horse_weight: 508,
          jockey_id: "05339",
          jockey_name: "C.ルメール",
          jockey_weight: 58.0,
          father_horse_name: "ディープインパクト",
          mother_horse_name: "マルペンサ"
        ),
        have_attributes(
          race_meta_id: @meta_11.id,
          bracket_number: 2,
          horse_number: 4,
          horse_id: "2013106099",
          horse_name: "ミッキーロケット",
          gender: "牡",
          age: 5,
          coat_color: "鹿毛",
          trainer_id: "01002",
          trainer_name: "音無 秀孝",
          horse_weight: 476,
          jockey_id: "01018",
          jockey_name: "和田 竜二",
          jockey_weight: 58.0,
          father_horse_name: "キングカメハメハ",
          mother_horse_name: "マネーキャントバイミーラヴ"
        ),
        have_attributes(
          race_meta_id: @meta_11.id,
          bracket_number: 3,
          horse_number: 5,
          horse_id: "2013110001",
          horse_name: "ストロングタイタン",
          gender: "牡",
          age: 5,
          coat_color: "鹿毛",
          trainer_id: "01071",
          trainer_name: "池江 泰寿",
          horse_weight: 522,
          jockey_id: "01088",
          jockey_name: "川田 将雅",
          jockey_weight: 58.0,
          father_horse_name: "Regal Ransom",
          mother_horse_name: "Titan Queen"
        ),
        have_attributes(
          race_meta_id: @meta_11.id,
          bracket_number: 3,
          horse_number: 6,
          horse_id: "2011104019",
          horse_name: "アルバート",
          gender: "牡",
          age: 7,
          coat_color: "栗毛",
          trainer_id: "01070",
          trainer_name: "堀 宣行",
          horse_weight: 480,
          jockey_id: "01116",
          jockey_name: "藤岡 康太",
          jockey_weight: 58.0,
          father_horse_name: "アドマイヤドン",
          mother_horse_name: "フォルクローレ"
        ),
        have_attributes(
          race_meta_id: @meta_11.id,
          bracket_number: 4,
          horse_number: 7,
          horse_id: "2012104503",
          horse_name: "パフォーマプロミス",
          gender: "牡",
          age: 6,
          coat_color: "栗毛",
          trainer_id: "01055",
          trainer_name: "藤原 英昭",
          horse_weight: 448,
          jockey_id: "05386",
          jockey_name: "戸崎 圭太",
          jockey_weight: 58.0,
          father_horse_name: "ステイゴールド",
          mother_horse_name: "アイルビーバウンド"
        ),
        have_attributes(
          race_meta_id: @meta_11.id,
          bracket_number: 4,
          horse_number: 8,
          horse_id: "2014106010",
          horse_name: "ダンビュライト",
          gender: "牡",
          age: 4,
          coat_color: "黒鹿毛",
          trainer_id: "01002",
          trainer_name: "音無 秀孝",
          horse_weight: 480,
          jockey_id: "00666",
          jockey_name: "武 豊",
          jockey_weight: 58.0,
          father_horse_name: "ルーラーシップ",
          mother_horse_name: "タンザナイト"
        ),
        have_attributes(
          race_meta_id: @meta_11.id,
          bracket_number: 5,
          horse_number: 9,
          horse_id: "2012104668",
          horse_name: "サトノクラウン",
          gender: "牡",
          age: 6,
          coat_color: "黒鹿毛",
          trainer_id: "01070",
          trainer_name: "堀 宣行",
          horse_weight: 482,
          jockey_id: "01077",
          jockey_name: "石橋 脩",
          jockey_weight: 58.0,
          father_horse_name: "Marju",
          mother_horse_name: "ジョコンダ2"
        ),
        have_attributes(
          race_meta_id: @meta_11.id,
          bracket_number: 5,
          horse_number: 10,
          horse_id: "2013106007",
          horse_name: "ヴィブロス",
          gender: "牝",
          age: 5,
          coat_color: "青毛",
          trainer_id: "01061",
          trainer_name: "友道 康夫",
          horse_weight: 440,
          jockey_id: "01014",
          jockey_name: "福永 祐一",
          jockey_weight: 56.0,
          father_horse_name: "ディープインパクト",
          mother_horse_name: "ハルーワスウィート"
        ),
        have_attributes(
          race_meta_id: @meta_11.id,
          bracket_number: 6,
          horse_number: 11,
          horse_id: "2010101161",
          horse_name: "サイモンラムセス",
          gender: "牡",
          age: 8,
          coat_color: "鹿毛",
          trainer_id: "01084",
          trainer_name: "梅田 智之",
          horse_weight: 454,
          jockey_id: "00894",
          jockey_name: "小牧 太",
          jockey_weight: 58.0,
          father_horse_name: "ブラックタイド",
          mother_horse_name: "コパノマルコリーニ"
        ),
        have_attributes(
          race_meta_id: @meta_11.id,
          bracket_number: 6,
          horse_number: 12,
          horse_id: "2012106426",
          horse_name: "タツゴウゲキ",
          gender: "牡",
          age: 6,
          coat_color: "鹿毛",
          trainer_id: "01046",
          trainer_name: "鮫島 一歩",
          horse_weight: 492,
          jockey_id: "01019",
          jockey_name: "秋山 真一郎",
          jockey_weight: 58.0,
          father_horse_name: "マーベラスサンデー",
          mother_horse_name: "ニシノプルメリア"
        ),
        have_attributes(
          race_meta_id: @meta_11.id,
          bracket_number: 7,
          horse_number: 13,
          horse_id: "2011190007",
          horse_name: "ワーザー",
          gender: "せん",
          age: 7,
          coat_color: "鹿毛",
          trainer_id: "05576",
          trainer_name: "J.ムーア",
          horse_weight: 446,
          jockey_id: "05529",
          jockey_name: "H.ボウマン",
          jockey_weight: 58.0,
          father_horse_name: "-",
          mother_horse_name: "-"
        ),
        have_attributes(
          race_meta_id: @meta_11.id,
          bracket_number: 7,
          horse_number: 14,
          horse_id: "2010102459",
          horse_name: "スマートレイアー",
          gender: "牝",
          age: 8,
          coat_color: "芦毛",
          trainer_id: "01058",
          trainer_name: "大久保 龍志",
          horse_weight: 468,
          jockey_id: "01126",
          jockey_name: "松山 弘平",
          jockey_weight: 56.0,
          father_horse_name: "ディープインパクト",
          mother_horse_name: "スノースタイル"
        ),
        have_attributes(
          race_meta_id: @meta_11.id,
          bracket_number: 8,
          horse_number: 15,
          horse_id: "2013105904",
          horse_name: "ゼーヴィント",
          gender: "牡",
          age: 5,
          coat_color: "鹿毛",
          trainer_id: "01126",
          trainer_name: "木村 哲也",
          horse_weight: 494,
          jockey_id: "01032",
          jockey_name: "池添 謙一",
          jockey_weight: 58.0,
          father_horse_name: "ディープインパクト",
          mother_horse_name: "シルキーラグーン"
        ),
        have_attributes(
          race_meta_id: @meta_11.id,
          bracket_number: 8,
          horse_number: 16,
          horse_id: "2014101976",
          horse_name: "キセキ",
          gender: "牡",
          age: 4,
          coat_color: "黒鹿毛",
          trainer_id: "01053",
          trainer_name: "角居 勝彦",
          horse_weight: 494,
          jockey_id: "05212",
          jockey_name: "M.デムーロ",
          jockey_weight: 58.0,
          father_horse_name: "ルーラーシップ",
          mother_horse_name: "ブリッツフィナーレ"
        ),
      ]
    end

    def build_expected_20190406
      [
        have_attributes(
          race_meta_id: @meta_20190406.id,
          bracket_number: 1,
          horse_number: 1,
          horse_id: "2014102733",
          horse_name: "ロイヤルメジャー",
          gender: "牝",
          age: 5,
          coat_color: "鹿毛",
          trainer_id: "00388",
          trainer_name: "山内 研二",
          horse_weight: 458,
          jockey_id: "01157",
          jockey_name: "鮫島 克駿",
          jockey_weight: 55.0,
          father_horse_name: "ダイワメジャー",
          mother_horse_name: "クリミナルコード"
        ),
        have_attributes(
          race_meta_id: @meta_20190406.id,
          bracket_number: 2,
          horse_number: 2,
          horse_id: "2013103801",
          horse_name: "ニシノラディアント",
          gender: "牡",
          age: 6,
          coat_color: "鹿毛",
          trainer_id: "01078",
          trainer_name: "北出 成人",
          horse_weight: 490,
          jockey_id: "01117",
          jockey_name: "丸田 恭介",
          jockey_weight: 57.0,
          father_horse_name: "アドマイヤマックス",
          mother_horse_name: "スターデュエット"
        ),
        have_attributes(
          race_meta_id: @meta_20190406.id,
          bracket_number: 2,
          horse_number: 3,
          horse_id: "2014105781",
          horse_name: "インシュラー",
          gender: "せん",
          age: 5,
          coat_color: "鹿毛",
          trainer_id: "00420",
          trainer_name: "宗像 義忠",
          horse_weight: 458,
          jockey_id: "01127",
          jockey_name: "丸山 元気",
          jockey_weight: 57.0,
          father_horse_name: "マンハッタンカフェ",
          mother_horse_name: "アイルドフランス"
        ),
        have_attributes(
          race_meta_id: @meta_20190406.id,
          bracket_number: 3,
          horse_number: 4,
          horse_id: "2015105214",
          horse_name: "メイケイダイハード",
          gender: "牡",
          age: 4,
          coat_color: "鹿毛",
          trainer_id: "01039",
          trainer_name: "中竹 和也",
          horse_weight: 532,
          jockey_id: "05243",
          jockey_name: "柴山 雄一",
          jockey_weight: 57.0,
          father_horse_name: "ハードスパン",
          mother_horse_name: "メイケイソフィア"
        ),
        have_attributes(
          race_meta_id: @meta_20190406.id,
          bracket_number: 3,
          horse_number: 5,
          horse_id: "2009100706",
          horse_name: "リバティーホール",
          gender: "牝",
          age: 10,
          coat_color: "鹿毛",
          trainer_id: "00436",
          trainer_name: "堀井 雅広",
          horse_weight: 448,
          jockey_id: "01004",
          jockey_name: "西田 雄一郎",
          jockey_weight: 55.0,
          father_horse_name: "ケイムホーム",
          mother_horse_name: "ムーンライトソナタ"
        ),
        have_attributes(
          race_meta_id: @meta_20190406.id,
          bracket_number: 4,
          horse_number: 6,
          horse_id: "2013101575",
          horse_name: "カネトシブレス",
          gender: "牝",
          age: 6,
          coat_color: "鹿毛",
          trainer_id: "01158",
          trainer_name: "寺島 良",
          horse_weight: 448,
          jockey_id: "01166",
          jockey_name: "川又 賢治",
          jockey_weight: 55.0,
          father_horse_name: "ダノンシャンティ",
          mother_horse_name: "カネトシレジアス"
        ),
        have_attributes(
          race_meta_id: @meta_20190406.id,
          bracket_number: 4,
          horse_number: 7,
          horse_id: "2013102031",
          horse_name: "チタンクレバー",
          gender: "牝",
          age: 6,
          coat_color: "青鹿毛",
          trainer_id: "00392",
          trainer_name: "古賀 史生",
          horse_weight: 446,
          jockey_id: "01025",
          jockey_name: "勝浦 正樹",
          jockey_weight: 55.0,
          father_horse_name: "ベーカバド",
          mother_horse_name: "ウインプラチナム"
        ),
        have_attributes(
          race_meta_id: @meta_20190406.id,
          bracket_number: 5,
          horse_number: 8,
          horse_id: "2015103673",
          horse_name: "トンボイ",
          gender: "牝",
          age: 4,
          coat_color: "栗毛",
          trainer_id: "01028",
          trainer_name: "西園 正都",
          horse_weight: 432,
          jockey_id: "01164",
          jockey_name: "藤田 菜七子",
          jockey_weight: 55.0,
          father_horse_name: "アドマイヤマックス",
          mother_horse_name: "ショウナンアオバ"
        ),
        have_attributes(
          race_meta_id: @meta_20190406.id,
          bracket_number: 5,
          horse_number: 9,
          horse_id: "2015100822",
          horse_name: "タイセイアベニール",
          gender: nil,
          age: nil,
          coat_color: nil,
          trainer_id: nil,
          trainer_name: nil,
          horse_weight: 476,
          jockey_id: "01092",
          jockey_name: "津村 明秀",
          jockey_weight: 57.0,
          father_horse_name: "ベーカバド",
          mother_horse_name: "ハロードリーム"
        ),
        have_attributes(
          race_meta_id: @meta_20190406.id,
          bracket_number: 6,
          horse_number: 10,
          horse_id: "2015103901",
          horse_name: "ディアサルファー",
          gender: "牝",
          age: 4,
          coat_color: "栗毛",
          trainer_id: "01052",
          trainer_name: "菊川 正達",
          horse_weight: 474,
          jockey_id: "01118",
          jockey_name: "宮崎 北斗",
          jockey_weight: 55.0,
          father_horse_name: "ローエングリン",
          mother_horse_name: "リバラン"
        ),
        have_attributes(
          race_meta_id: @meta_20190406.id,
          bracket_number: 6,
          horse_number: 11,
          horse_id: "2014103601",
          horse_name: "ゲンパチケンシン",
          gender: "牡",
          age: 5,
          coat_color: "芦毛",
          trainer_id: "00425",
          trainer_name: "加用 正",
          horse_weight: 474,
          jockey_id: "01171",
          jockey_name: "西村 淳也",
          jockey_weight: 57.0,
          father_horse_name: "クロフネ",
          mother_horse_name: "レチャーダ"
        ),
        have_attributes(
          race_meta_id: @meta_20190406.id,
          bracket_number: 7,
          horse_number: 12,
          horse_id: "2014100253",
          horse_name: "ペスカネラ",
          gender: "牝",
          age: 5,
          coat_color: "黒鹿毛",
          trainer_id: "01149",
          trainer_name: "松下 武士",
          horse_weight: 442,
          jockey_id: "01038",
          jockey_name: "中谷 雄太",
          jockey_weight: 55.0,
          father_horse_name: "ブラックタイド",
          mother_horse_name: "ピーチドラフト"
        ),
        have_attributes(
          race_meta_id: @meta_20190406.id,
          bracket_number: 7,
          horse_number: 13,
          horse_id: "2015100673",
          horse_name: "コーラルリーフ",
          gender: "牝",
          age: 4,
          coat_color: "栗毛",
          trainer_id: "01073",
          trainer_name: "宮本 博",
          horse_weight: 416,
          jockey_id: "01170",
          jockey_name: "横山 武史",
          jockey_weight: 55.0,
          father_horse_name: "ヨハネスブルグ",
          mother_horse_name: "フィーユ"
        ),
        have_attributes(
          race_meta_id: @meta_20190406.id,
          bracket_number: 8,
          horse_number: 14,
          horse_id: "2015105192",
          horse_name: "ブルレジーナ",
          gender: "牝",
          age: 4,
          coat_color: "栗毛",
          trainer_id: "01085",
          trainer_name: "小崎 憲",
          horse_weight: 446,
          jockey_id: "01144",
          jockey_name: "菱田 裕二",
          jockey_weight: 55.0,
          father_horse_name: "ハーツクライ",
          mother_horse_name: "リキオリンピア"
        ),
        have_attributes(
          race_meta_id: @meta_20190406.id,
          bracket_number: 8,
          horse_number: 15,
          horse_id: "2015102817",
          horse_name: "メイショウツバキ",
          gender: "牝",
          age: 4,
          coat_color: "黒鹿毛",
          trainer_id: "00434",
          trainer_name: "西橋 豊治",
          horse_weight: 450,
          jockey_id: "01168",
          jockey_name: "富田 暁",
          jockey_weight: 55.0,
          father_horse_name: "メイショウサムソン",
          mother_horse_name: "メイショウラグーナ"
        ),
      ]
    end
  end
end
