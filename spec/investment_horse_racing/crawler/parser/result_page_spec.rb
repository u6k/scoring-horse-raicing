require "timecop"

require "spec_helper"

RSpec.describe InvestmentHorseRacing::Crawler::Parser::ResultPageParser do
  before do
    # 2018-06-24 hanshin no 1 race result page parser
    url = "https://keiba.yahoo.co.jp/race/result/1809030801/"
    data = {
      "url" => "https://keiba.yahoo.co.jp/race/result/1809030801/",
      "request_method" => "GET",
      "request_headers" => {},
      "response_headers" => {},
      "response_body" => File.open("spec/data/result.20180624.hanshin.1.html").read,
      "downloaded_timestamp" => Time.utc(2018, 6, 24, 0, 0, 0)}

    @parser = InvestmentHorseRacing::Crawler::Parser::ResultPageParser.new(url, data)

    # 1986-01-26 tyukyou no 11 race result page parser
    url = "https://keiba.yahoo.co.jp/race/result/8607010211/"
    data = {
      "url" => "https://keiba.yahoo.co.jp/race/result/8607010211/",
      "request_method" => "GET",
      "request_headers" => {},
      "response_headers" => {},
      "response_body" => File.open("spec/data/result.19860126.tyukyou.11.html").read,
      "downloaded_timestamp" => Time.now}

    @parser_19860126 = InvestmentHorseRacing::Crawler::Parser::ResultPageParser.new(url, data)

    # error page parser
    url = "https://keiba.yahoo.co.jp/race/result/0000000000/"
    data = File.open("spec/data/result.0000000000.error.html").read

    @parser_error = InvestmentHorseRacing::Crawler::Parser::ResultPageParser.new(url, data)
  end

  describe "#redownload?" do
    context "2018-06-24 hanshin no 1 race result page" do
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

    context "1986-01-26 tyukyou no 11 race result page" do
      it "do not redownload" do
        expect(@parser_19860126).not_to be_redownload
      end
    end
  end

  describe "#related_links" do
    context "2018-06-24 hanshin no 1 race result page" do
      it "is denma, odds, horse, jocky, trainer pages" do
        expect(@parser.related_links).to contain_exactly(
          "https://keiba.yahoo.co.jp/race/denma/1809030801/",
          "https://keiba.yahoo.co.jp/odds/tfw/1809030801/")
      end
    end

    context "1986-01-26 tyukyou no 11 race result page" do
      it "is horse, jocky, trainer pages" do
        expect(@parser_19860126.related_links).to be_empty
      end
    end
  end

  describe "#parse" do
    before do
      InvestmentHorseRacing::Crawler::Model::RaceMeta.destroy_all
    end

    context "2018-06-24 hanshin no 1 race result page" do
      it "is result info" do
        context = {}

        @parser.parse(context)

        expect(context).to be_empty

        expect(InvestmentHorseRacing::Crawler::Model::RaceMeta.all).to match_array([
          have_attributes(race_id: "1809030801",
                          race_number: 1,
                          start_datetime: Time.new(2018, 6, 24, 10, 5, 0),
                          race_name: "サラ系3歳未勝利",
                          course_name: "阪神",
                          course_length: "ダート・右 1400m",
                          weather: "晴",
                          course_condition: "重",
                          race_class: "サラ系3歳",
                          prize_class: "未勝利 牝 [指定] 馬齢")
        ])

        meta = InvestmentHorseRacing::Crawler::Model::RaceMeta.first

        expect(InvestmentHorseRacing::Crawler::Model::RaceRefund.all).to match_array([
          have_attributes(race_meta_id: meta.id, refund_type: "win", horse_numbers: "14", money: 290),
          have_attributes(race_meta_id: meta.id, refund_type: "place", horse_numbers: "14", money: 130),
          have_attributes(race_meta_id: meta.id, refund_type: "place", horse_numbers: "1", money: 190),
          have_attributes(race_meta_id: meta.id, refund_type: "place", horse_numbers: "15", money: 310),
          have_attributes(race_meta_id: meta.id, refund_type: "bracket_quinella", horse_numbers: "1-7", money: 700),
          have_attributes(race_meta_id: meta.id, refund_type: "quinella", horse_numbers: "1-14", money: 1190),
          have_attributes(race_meta_id: meta.id, refund_type: "quinella_place", horse_numbers: "1-14", money: 400),
          have_attributes(race_meta_id: meta.id, refund_type: "quinella_place", horse_numbers: "1-15", money: 1730),
          have_attributes(race_meta_id: meta.id, refund_type: "quinella_place", horse_numbers: "14-15", money: 790),
          have_attributes(race_meta_id: meta.id, refund_type: "exacta", horse_numbers: "14-1", money: 2030),
          have_attributes(race_meta_id: meta.id, refund_type: "trio", horse_numbers: "1-14-15", money: 4270),
          have_attributes(race_meta_id: meta.id, refund_type: "tierce", horse_numbers: "14-1-15", money: 17660),
        ])

        expect(InvestmentHorseRacing::Crawler::Model::RaceScore.all).to match_array([
          have_attributes(race_meta_id: meta.id, rank: 1, bracket_number: 7, horse_number: 14, time: 83.9),
          have_attributes(race_meta_id: meta.id, rank: 2, bracket_number: 1, horse_number: 1, time: 85.3),
          have_attributes(race_meta_id: meta.id, rank: 3, bracket_number: 8, horse_number: 15, time: 85.4),
          have_attributes(race_meta_id: meta.id, rank: 4, bracket_number: 6, horse_number: 12, time: 85.5),
          have_attributes(race_meta_id: meta.id, rank: 5, bracket_number: 3, horse_number: 5, time: 85.7),
          have_attributes(race_meta_id: meta.id, rank: 6, bracket_number: 3, horse_number: 6, time: 85.7),
          have_attributes(race_meta_id: meta.id, rank: 7, bracket_number: 5, horse_number: 10, time: 85.7),
          have_attributes(race_meta_id: meta.id, rank: 8, bracket_number: 2, horse_number: 4, time: 85.9),
          have_attributes(race_meta_id: meta.id, rank: 9, bracket_number: 4, horse_number: 8, time: 85.9),
          have_attributes(race_meta_id: meta.id, rank: 10, bracket_number: 2, horse_number: 3, time: 87.3),
          have_attributes(race_meta_id: meta.id, rank: 11, bracket_number: 8, horse_number: 16, time: 87.5),
          have_attributes(race_meta_id: meta.id, rank: 12, bracket_number: 1, horse_number: 2, time: 87.5),
          have_attributes(race_meta_id: meta.id, rank: 13, bracket_number: 5, horse_number: 9, time: 87.6),
          have_attributes(race_meta_id: meta.id, rank: 14, bracket_number: 7, horse_number: 13, time: 87.8),
          have_attributes(race_meta_id: meta.id, rank: 15, bracket_number: 6, horse_number: 11, time: 88.3),
          have_attributes(race_meta_id: meta.id, rank: 16, bracket_number: 4, horse_number: 7, time: 90.5),
        ])
      end
    end

    context "existing data" do
      before do
        @meta_11111 = InvestmentHorseRacing::Crawler::Model::RaceMeta.create(race_id: "11111")
        @meta = InvestmentHorseRacing::Crawler::Model::RaceMeta.create(race_id: "1809030801")
        @meta_22222 = InvestmentHorseRacing::Crawler::Model::RaceMeta.create(race_id: "22222")

        InvestmentHorseRacing::Crawler::Model::RaceRefund.create(race_meta: @meta_11111, money: 111)
        InvestmentHorseRacing::Crawler::Model::RaceRefund.create(race_meta: @meta_11111, money: 222)
        InvestmentHorseRacing::Crawler::Model::RaceRefund.create(race_meta: @meta_11111, money: 333)

        InvestmentHorseRacing::Crawler::Model::RaceRefund.create(race_meta: @meta, money: 111)
        InvestmentHorseRacing::Crawler::Model::RaceRefund.create(race_meta: @meta, money: 222)
        InvestmentHorseRacing::Crawler::Model::RaceRefund.create(race_meta: @meta, money: 333)

        InvestmentHorseRacing::Crawler::Model::RaceRefund.create(race_meta: @meta_22222, money: 111)
        InvestmentHorseRacing::Crawler::Model::RaceRefund.create(race_meta: @meta_22222, money: 222)
        InvestmentHorseRacing::Crawler::Model::RaceRefund.create(race_meta: @meta_22222, money: 333)

        InvestmentHorseRacing::Crawler::Model::RaceScore.create(race_meta: @meta_11111, rank: 1)
        InvestmentHorseRacing::Crawler::Model::RaceScore.create(race_meta: @meta_11111, rank: 2)
        InvestmentHorseRacing::Crawler::Model::RaceScore.create(race_meta: @meta_11111, rank: 3)

        InvestmentHorseRacing::Crawler::Model::RaceScore.create(race_meta: @meta, rank: 1)
        InvestmentHorseRacing::Crawler::Model::RaceScore.create(race_meta: @meta, rank: 2)
        InvestmentHorseRacing::Crawler::Model::RaceScore.create(race_meta: @meta, rank: 3)

        InvestmentHorseRacing::Crawler::Model::RaceScore.create(race_meta: @meta_22222, rank: 1)
        InvestmentHorseRacing::Crawler::Model::RaceScore.create(race_meta: @meta_22222, rank: 2)
        InvestmentHorseRacing::Crawler::Model::RaceScore.create(race_meta: @meta_22222, rank: 3)
      end

      it "is result info" do
        context = {}

        @parser.parse(context)

        expect(context).to be_empty

        expect(InvestmentHorseRacing::Crawler::Model::RaceMeta.all).to match_array([
          have_attributes(race_id: "11111"),
          have_attributes(race_id: "22222"),
          have_attributes(race_id: "1809030801",
                          race_number: 1,
                          start_datetime: Time.new(2018, 6, 24, 10, 5, 0),
                          race_name: "サラ系3歳未勝利",
                          course_name: "阪神",
                          course_length: "ダート・右 1400m",
                          weather: "晴",
                          course_condition: "重",
                          race_class: "サラ系3歳",
                          prize_class: "未勝利 牝 [指定] 馬齢")
        ])

        @meta = InvestmentHorseRacing::Crawler::Model::RaceMeta.where(race_id: "1809030801").first

        expect(InvestmentHorseRacing::Crawler::Model::RaceRefund.all).to match_array([
          have_attributes(race_meta_id: @meta_11111.id, refund_type: nil, horse_numbers: nil, money: 111),
          have_attributes(race_meta_id: @meta_11111.id, refund_type: nil, horse_numbers: nil, money: 222),
          have_attributes(race_meta_id: @meta_11111.id, refund_type: nil, horse_numbers: nil, money: 333),
          have_attributes(race_meta_id: @meta.id, refund_type: "win", horse_numbers: "14", money: 290),
          have_attributes(race_meta_id: @meta.id, refund_type: "place", horse_numbers: "14", money: 130),
          have_attributes(race_meta_id: @meta.id, refund_type: "place", horse_numbers: "1", money: 190),
          have_attributes(race_meta_id: @meta.id, refund_type: "place", horse_numbers: "15", money: 310),
          have_attributes(race_meta_id: @meta.id, refund_type: "bracket_quinella", horse_numbers: "1-7", money: 700),
          have_attributes(race_meta_id: @meta.id, refund_type: "quinella", horse_numbers: "1-14", money: 1190),
          have_attributes(race_meta_id: @meta.id, refund_type: "quinella_place", horse_numbers: "1-14", money: 400),
          have_attributes(race_meta_id: @meta.id, refund_type: "quinella_place", horse_numbers: "1-15", money: 1730),
          have_attributes(race_meta_id: @meta.id, refund_type: "quinella_place", horse_numbers: "14-15", money: 790),
          have_attributes(race_meta_id: @meta.id, refund_type: "exacta", horse_numbers: "14-1", money: 2030),
          have_attributes(race_meta_id: @meta.id, refund_type: "trio", horse_numbers: "1-14-15", money: 4270),
          have_attributes(race_meta_id: @meta.id, refund_type: "tierce", horse_numbers: "14-1-15", money: 17660),
          have_attributes(race_meta_id: @meta_22222.id, refund_type: nil, horse_numbers: nil, money: 111),
          have_attributes(race_meta_id: @meta_22222.id, refund_type: nil, horse_numbers: nil, money: 222),
          have_attributes(race_meta_id: @meta_22222.id, refund_type: nil, horse_numbers: nil, money: 333),
        ])

        expect(InvestmentHorseRacing::Crawler::Model::RaceScore.all).to match_array([
          have_attributes(race_meta_id: @meta_11111.id, rank: 1, bracket_number: nil, horse_number: nil, time: nil),
          have_attributes(race_meta_id: @meta_11111.id, rank: 2, bracket_number: nil, horse_number: nil, time: nil),
          have_attributes(race_meta_id: @meta_11111.id, rank: 3, bracket_number: nil, horse_number: nil, time: nil),
          have_attributes(race_meta_id: @meta.id, rank: 1, bracket_number: 7, horse_number: 14, time: 83.9),
          have_attributes(race_meta_id: @meta.id, rank: 2, bracket_number: 1, horse_number: 1, time: 85.3),
          have_attributes(race_meta_id: @meta.id, rank: 3, bracket_number: 8, horse_number: 15, time: 85.4),
          have_attributes(race_meta_id: @meta.id, rank: 4, bracket_number: 6, horse_number: 12, time: 85.5),
          have_attributes(race_meta_id: @meta.id, rank: 5, bracket_number: 3, horse_number: 5, time: 85.7),
          have_attributes(race_meta_id: @meta.id, rank: 6, bracket_number: 3, horse_number: 6, time: 85.7),
          have_attributes(race_meta_id: @meta.id, rank: 7, bracket_number: 5, horse_number: 10, time: 85.7),
          have_attributes(race_meta_id: @meta.id, rank: 8, bracket_number: 2, horse_number: 4, time: 85.9),
          have_attributes(race_meta_id: @meta.id, rank: 9, bracket_number: 4, horse_number: 8, time: 85.9),
          have_attributes(race_meta_id: @meta.id, rank: 10, bracket_number: 2, horse_number: 3, time: 87.3),
          have_attributes(race_meta_id: @meta.id, rank: 11, bracket_number: 8, horse_number: 16, time: 87.5),
          have_attributes(race_meta_id: @meta.id, rank: 12, bracket_number: 1, horse_number: 2, time: 87.5),
          have_attributes(race_meta_id: @meta.id, rank: 13, bracket_number: 5, horse_number: 9, time: 87.6),
          have_attributes(race_meta_id: @meta.id, rank: 14, bracket_number: 7, horse_number: 13, time: 87.8),
          have_attributes(race_meta_id: @meta.id, rank: 15, bracket_number: 6, horse_number: 11, time: 88.3),
          have_attributes(race_meta_id: @meta.id, rank: 16, bracket_number: 4, horse_number: 7, time: 90.5),
          have_attributes(race_meta_id: @meta_22222.id, rank: 1, bracket_number: nil, horse_number: nil, time: nil),
          have_attributes(race_meta_id: @meta_22222.id, rank: 2, bracket_number: nil, horse_number: nil, time: nil),
          have_attributes(race_meta_id: @meta_22222.id, rank: 3, bracket_number: nil, horse_number: nil, time: nil),
        ])
      end
    end

    context "1986-01-26 tyukyou no 11 race result page" do
      it "is result info" do
        context = {}

        @parser_19860126.parse(context)

        expect(context).to be_empty

        expect(InvestmentHorseRacing::Crawler::Model::RaceMeta.all).to match_array([
          have_attributes(race_id: "8607010211",
                          race_number: 11,
                          start_datetime: Time.new(1986, 1, 26, 15, 35, 0),
                          race_name: "中京スポーツ杯",
                          course_name: "中京",
                          course_length: "芝・左 1800m",
                          weather: "曇",
                          course_condition: "良",
                          race_class: "サラ系5歳以上",
                          prize_class: "900万下 （混合） 馬齢")
        ])

        meta = InvestmentHorseRacing::Crawler::Model::RaceMeta.first

        expect(InvestmentHorseRacing::Crawler::Model::RaceRefund.all).to match_array([
          have_attributes(race_meta_id: meta.id, refund_type: "win", horse_numbers: "9", money: 720),
          have_attributes(race_meta_id: meta.id, refund_type: "place", horse_numbers: "9", money: 180),
          have_attributes(race_meta_id: meta.id, refund_type: "place", horse_numbers: "8", money: 370),
          have_attributes(race_meta_id: meta.id, refund_type: "place", horse_numbers: "12", money: 240),
          have_attributes(race_meta_id: meta.id, refund_type: "bracket_quinella", horse_numbers: "4-5", money: 2980),
        ])

        expect(InvestmentHorseRacing::Crawler::Model::RaceScore.all).to match_array([
          have_attributes(race_meta_id: meta.id, rank: 1, bracket_number: 5, horse_number: 9, time: 109.8),
          have_attributes(race_meta_id: meta.id, rank: 2, bracket_number: 4, horse_number: 8, time: 109.8),
          have_attributes(race_meta_id: meta.id, rank: 3, bracket_number: 6, horse_number: 12, time: 110.1),
          have_attributes(race_meta_id: meta.id, rank: 4, bracket_number: 7, horse_number: 14, time: 110.2),
          have_attributes(race_meta_id: meta.id, rank: 5, bracket_number: 3, horse_number: 5, time: 110.3),
          have_attributes(race_meta_id: meta.id, rank: 6, bracket_number: 1, horse_number: 2, time: 110.3),
          have_attributes(race_meta_id: meta.id, rank: 7, bracket_number: 4, horse_number: 7, time: 110.4),
          have_attributes(race_meta_id: meta.id, rank: 8, bracket_number: 2, horse_number: 3, time: 110.5),
          have_attributes(race_meta_id: meta.id, rank: 9, bracket_number: 2, horse_number: 4, time: 110.6),
          have_attributes(race_meta_id: meta.id, rank: 10, bracket_number: 6, horse_number: 11, time: 110.6),
          have_attributes(race_meta_id: meta.id, rank: 11, bracket_number: 7, horse_number: 13, time: 110.8),
          have_attributes(race_meta_id: meta.id, rank: 12, bracket_number: 3, horse_number: 6, time: 111.0),
          have_attributes(race_meta_id: meta.id, rank: 13, bracket_number: 1, horse_number: 1, time: 111.3),
          have_attributes(race_meta_id: meta.id, rank: 14, bracket_number: 8, horse_number: 16, time: 111.3),
          have_attributes(race_meta_id: meta.id, rank: 15, bracket_number: 5, horse_number: 10, time: 112.0),
          have_attributes(race_meta_id: meta.id, rank: nil, bracket_number: 8, horse_number: 15, time: nil),
        ])
      end
    end
  end
end
