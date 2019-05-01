require "timecop"

require "spec_helper"

RSpec.describe InvestmentHorseRacing::Crawler::Parser::EntryPageParser do
  before do
    # Setup data
    InvestmentHorseRacing::Crawler::Model::RaceMeta.destroy_all

    ## 2018-06-24 hanshin no 1 race result data
    url = "https://keiba.yahoo.co.jp/race/result/1809030801/"
    data = {
      "url" => "https://keiba.yahoo.co.jp/race/result/1809030801/",
      "request_method" => "GET",
      "request_headers" => {},
      "response_headers" => {},
      "response_body" => File.open("spec/data/result.20180624.hanshin.1.html").read,
      "downloaded_timestamp" => Time.utc(2018, 6, 24, 0, 0, 0)}

    parser = InvestmentHorseRacing::Crawler::Parser::ResultPageParser.new(url, data)
    parser.parse({})

    @meta = InvestmentHorseRacing::Crawler::Model::RaceMeta.find_by(race_id: "1809030801")

    ## 2018-06-24 hanshin no 11 race result data
    url = "https://keiba.yahoo.co.jp/race/result/1809030811/"
    data = {
      "url" => "https://keiba.yahoo.co.jp/race/result/1809030811/",
      "request_method" => "GET",
      "request_headers" => {},
      "response_headers" => {},
      "response_body" => File.open("spec/data/result.20180624.hanshin.11.html").read,
      "downloaded_timestamp" => Time.utc(2018, 6, 24, 0, 0, 0)}

    parser = InvestmentHorseRacing::Crawler::Parser::ResultPageParser.new(url, data)
    parser.parse({})

    @meta_11 = InvestmentHorseRacing::Crawler::Model::RaceMeta.find_by(race_id: "1809030811")

    ## error race meta data
    InvestmentHorseRacing::Crawler::Model::RaceMeta.create(race_id: "0000000000")

    # Setup parser
    ## 2018-06-24 hanshin no 1 race entry page parser
    url = "https://keiba.yahoo.co.jp/race/denma/1809030801/"
    data = {
      "url" => "https://keiba.yahoo.co.jp/race/denma/1809030801/",
      "request_method" => "GET",
      "request_headers" => {},
      "response_headers" => {},
      "response_body" => File.open("spec/data/entry.20180624.hanshin.1.html").read,
      "downloaded_timestamp" => Time.utc(2018, 6, 24, 0, 0, 0)}

    @parser = InvestmentHorseRacing::Crawler::Parser::EntryPageParser.new(url, data)

    ## 2018-06-24 hanshin no 11 race entry page parser
    url = "https://keiba.yahoo.co.jp/race/denma/1809030811/"
    data = {
      "url" => "https://keiba.yahoo.co.jp/race/denma/1809030811/",
      "request_method" => "GET",
      "request_headers" => {},
      "response_headers" => {},
      "response_body" => File.open("spec/data/entry.20180624.hanshin.11.html").read,
      "downloaded_timestamp" => Time.utc(2018, 6, 24, 11, 12, 13)}

    @parser_11 = InvestmentHorseRacing::Crawler::Parser::EntryPageParser.new(url, data)

    ## error page parser
    url = "https://keiba.yahoo.co.jp/race/denma/0000000000/"
    data = {
      "url" => "https://keiba.yahoo.co.jp/race/denma/0000000000/",
      "request_method" => "GET",
      "request_headers" => {},
      "response_headers" => {},
      "response_body" => File.open("spec/data/entry.0000000000.error.html").read,
      "downloaded_timestamp" => Time.now}

    @parser_error = InvestmentHorseRacing::Crawler::Parser::EntryPageParser.new(url, data)
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

        expect(InvestmentHorseRacing::Crawler::Model::RaceEntry.all).to match_array([
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
        ])
      end
    end

    context "2018-06-24 hanshin no 11 race entry page" do
      it "is entry info" do
        context = {}

        @parser_11.parse(context)

        expect(context).to be_empty

        expect(InvestmentHorseRacing::Crawler::Model::RaceEntry.all).to match_array([
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
        ])
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

        expect(InvestmentHorseRacing::Crawler::Model::RaceEntry.all).to match_array([
          have_attributes(
            race_meta_id: @meta_11111.id,
            horse_id: "11111-11111"
          ),
          have_attributes(
            race_meta_id: @meta_11111.id,
            horse_id: "11111-22222"
          ),
          have_attributes(
            race_meta_id: @meta_11111.id,
            horse_id: "11111-33333"
          ),
          have_attributes(
            race_meta_id: @meta_22222.id,
            horse_id: "22222-11111"
          ),
          have_attributes(
            race_meta_id: @meta_22222.id,
            horse_id: "22222-22222"
          ),
          have_attributes(
            race_meta_id: @meta_22222.id,
            horse_id: "22222-33333"
          ),
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
        ])
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
  end
end
