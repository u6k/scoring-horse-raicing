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
      it "redownload if newer than 2 months" do
        Timecop.freeze(Time.local(2018, 9, 21)) do
          expect(@parser).to be_redownload
        end
      end

      it "do not redownload if over 3 months old" do
        Timecop.freeze(Time.local(2018, 9, 22)) do
          expect(@parser).not_to be_redownload
        end
      end

      it "redownload if 1 day has passed" do
        Timecop.freeze(Time.utc(2018, 6, 25, 0, 0, 0)) do
          expect(@parser).to be_redownload
        end
      end

      it "do not redownload within 1 day" do
        Timecop.freeze(Time.utc(2018, 6, 24, 23, 59, 59)) do
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

  describe "#valid?" do
    context "2018-06-24 hanshin no 1 race result page" do
      it "is valid" do
        expect(@parser).to be_valid
      end
    end

    context "1986-01-26 tyukyou no 11 race result page" do
      it "is valid" do
        expect(@parser_19860126).to be_valid
      end
    end

    context "error page" do
      it "is invalid" do
        expect(@parser_error).not_to be_valid
      end
    end
  end

  describe "#related_links" do
    context "2018-06-24 hanshin no 1 race result page" do
      it "is denma, odds, horse, jocky, trainer pages" do
        expect(@parser.related_links).to contain_exactly(
          "https://keiba.yahoo.co.jp/race/denma/1809030801/",
          "https://keiba.yahoo.co.jp/odds/tfw/1809030801/",
          "https://keiba.yahoo.co.jp/directory/horse/2015103590/",
          "https://keiba.yahoo.co.jp/directory/horse/2015104308/",
          "https://keiba.yahoo.co.jp/directory/horse/2015104979/",
          "https://keiba.yahoo.co.jp/directory/horse/2015102853/",
          "https://keiba.yahoo.co.jp/directory/horse/2015103335/",
          "https://keiba.yahoo.co.jp/directory/horse/2015104928/",
          "https://keiba.yahoo.co.jp/directory/horse/2015105363/",
          "https://keiba.yahoo.co.jp/directory/horse/2015100586/",
          "https://keiba.yahoo.co.jp/directory/horse/2015102694/",
          "https://keiba.yahoo.co.jp/directory/horse/2015100632/",
          "https://keiba.yahoo.co.jp/directory/horse/2015103557/",
          "https://keiba.yahoo.co.jp/directory/horse/2015104964/",
          "https://keiba.yahoo.co.jp/directory/horse/2015102837/",
          "https://keiba.yahoo.co.jp/directory/horse/2015103462/",
          "https://keiba.yahoo.co.jp/directory/horse/2015101618/",
          "https://keiba.yahoo.co.jp/directory/horse/2015106259/",
          "https://keiba.yahoo.co.jp/directory/jocky/05386/",
          "https://keiba.yahoo.co.jp/directory/jocky/05339/",
          "https://keiba.yahoo.co.jp/directory/jocky/01116/",
          "https://keiba.yahoo.co.jp/directory/jocky/01018/",
          "https://keiba.yahoo.co.jp/directory/jocky/01165/",
          "https://keiba.yahoo.co.jp/directory/jocky/00894/",
          "https://keiba.yahoo.co.jp/directory/jocky/01019/",
          "https://keiba.yahoo.co.jp/directory/jocky/01114/",
          "https://keiba.yahoo.co.jp/directory/jocky/05203/",
          "https://keiba.yahoo.co.jp/directory/jocky/01088/",
          "https://keiba.yahoo.co.jp/directory/jocky/01154/",
          "https://keiba.yahoo.co.jp/directory/jocky/01014/",
          "https://keiba.yahoo.co.jp/directory/jocky/01126/",
          "https://keiba.yahoo.co.jp/directory/jocky/01130/",
          "https://keiba.yahoo.co.jp/directory/jocky/01166/",
          "https://keiba.yahoo.co.jp/directory/jocky/01034/",
          "https://keiba.yahoo.co.jp/directory/trainer/01157/",
          "https://keiba.yahoo.co.jp/directory/trainer/01120/",
          "https://keiba.yahoo.co.jp/directory/trainer/00438/",
          "https://keiba.yahoo.co.jp/directory/trainer/01111/",
          "https://keiba.yahoo.co.jp/directory/trainer/01041/",
          "https://keiba.yahoo.co.jp/directory/trainer/01073/",
          "https://keiba.yahoo.co.jp/directory/trainer/01138/",
          "https://keiba.yahoo.co.jp/directory/trainer/01140/",
          "https://keiba.yahoo.co.jp/directory/trainer/01104/",
          "https://keiba.yahoo.co.jp/directory/trainer/01046/",
          "https://keiba.yahoo.co.jp/directory/trainer/01022/",
          "https://keiba.yahoo.co.jp/directory/trainer/01022/",
          "https://keiba.yahoo.co.jp/directory/trainer/01050/",
          "https://keiba.yahoo.co.jp/directory/trainer/00356/",
          "https://keiba.yahoo.co.jp/directory/trainer/01066/",
          "https://keiba.yahoo.co.jp/directory/trainer/01078/")
      end
    end

    context "1986-01-26 tyukyou no 11 race result page" do
      it "is horse, jocky, trainer pages" do
        expect(@parser_19860126.related_links).to contain_exactly(
          "https://keiba.yahoo.co.jp/directory/horse/1981105030/",
          "https://keiba.yahoo.co.jp/directory/horse/1982101926/",
          "https://keiba.yahoo.co.jp/directory/horse/1980102195/",
          "https://keiba.yahoo.co.jp/directory/horse/1981105305/",
          "https://keiba.yahoo.co.jp/directory/horse/1980106560/",
          "https://keiba.yahoo.co.jp/directory/horse/1981103008/",
          "https://keiba.yahoo.co.jp/directory/horse/1980100417/",
          "https://keiba.yahoo.co.jp/directory/horse/1982104865/",
          "https://keiba.yahoo.co.jp/directory/horse/1981102714/",
          "https://keiba.yahoo.co.jp/directory/horse/1982101034/",
          "https://keiba.yahoo.co.jp/directory/horse/1980102046/",
          "https://keiba.yahoo.co.jp/directory/horse/1981105157/",
          "https://keiba.yahoo.co.jp/directory/horse/1982107263/",
          "https://keiba.yahoo.co.jp/directory/horse/1982101932/",
          "https://keiba.yahoo.co.jp/directory/horse/1982106904/",
          "https://keiba.yahoo.co.jp/directory/horse/1980102147/",
          "https://keiba.yahoo.co.jp/directory/jocky/00352/",
          "https://keiba.yahoo.co.jp/directory/jocky/00615/",
          "https://keiba.yahoo.co.jp/directory/jocky/00337/",
          "https://keiba.yahoo.co.jp/directory/jocky/00227/",
          "https://keiba.yahoo.co.jp/directory/jocky/00518/",
          "https://keiba.yahoo.co.jp/directory/jocky/00348/",
          "https://keiba.yahoo.co.jp/directory/jocky/00302/",
          "https://keiba.yahoo.co.jp/directory/jocky/00605/",
          "https://keiba.yahoo.co.jp/directory/jocky/00108/",
          "https://keiba.yahoo.co.jp/directory/jocky/00627/",
          "https://keiba.yahoo.co.jp/directory/jocky/00246/",
          "https://keiba.yahoo.co.jp/directory/jocky/00298/",
          "https://keiba.yahoo.co.jp/directory/jocky/00513/",
          "https://keiba.yahoo.co.jp/directory/jocky/00163/",
          "https://keiba.yahoo.co.jp/directory/jocky/00571/",
          "https://keiba.yahoo.co.jp/directory/jocky/00258/",
          "https://keiba.yahoo.co.jp/directory/trainer/00236/",
          "https://keiba.yahoo.co.jp/directory/trainer/00119/",
          "https://keiba.yahoo.co.jp/directory/trainer/00104/",
          "https://keiba.yahoo.co.jp/directory/trainer/00237/",
          "https://keiba.yahoo.co.jp/directory/trainer/00239/",
          "https://keiba.yahoo.co.jp/directory/trainer/00311/",
          "https://keiba.yahoo.co.jp/directory/trainer/00333/",
          "https://keiba.yahoo.co.jp/directory/trainer/00352/",
          "https://keiba.yahoo.co.jp/directory/trainer/00343/",
          "https://keiba.yahoo.co.jp/directory/trainer/00279/",
          "https://keiba.yahoo.co.jp/directory/trainer/00170/",
          "https://keiba.yahoo.co.jp/directory/trainer/00128/",
          "https://keiba.yahoo.co.jp/directory/trainer/00262/",
          "https://keiba.yahoo.co.jp/directory/trainer/00297/",
          "https://keiba.yahoo.co.jp/directory/trainer/00194/",
          "https://keiba.yahoo.co.jp/directory/trainer/00140/")
      end
    end
  end

  describe "#parse" do
    context "2018-06-24 hanshin no 1 race result page" do
      it "is result info" do
        context = {}

        @parser.parse(context)

        # TODO: Parse all result info
        expect(context).to match(
          "results" => {
            "1809030801" => {
              "result_id" => "1809030801",
              "race_number" => 1,
              "start_datetime" => Time.new(2018, 6, 24, 10, 5, 0),
              "race_name" => "サラ系3歳未勝利",
              "cource_name" => "阪神"
            }
          })
      end
    end

    context "1986-01-26 tyukyou no 11 race result page" do
      it "is result info" do
        context = {}

        @parser_19860126.parse(context)

        # TODO: Parse all result info
        expect(context).to match(
          "results" => {
            "8607010211" => {
              "result_id" => "8607010211",
              "race_number" => 11,
              "start_datetime" => Time.new(1986, 1, 26, 15, 35, 0),
              "race_name" => "中京スポーツ杯",
              "cource_name" => "中京"
            }
          })
      end
    end
  end
end
