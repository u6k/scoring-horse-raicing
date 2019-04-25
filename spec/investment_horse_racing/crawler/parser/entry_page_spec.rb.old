require "timecop"

require "spec_helper"

RSpec.describe InvestmentHorseRacing::Crawler::Parser::EntryPageParser do
  before do
    # 2018-06-24 hanshin no 1 race entry page parser
    url = "https://keiba.yahoo.co.jp/race/denma/1809030801/"
    data = {
      "url" => "https://keiba.yahoo.co.jp/race/denma/1809030801/",
      "request_method" => "GET",
      "request_headers" => {},
      "response_headers" => {},
      "response_body" => File.open("spec/data/entry.20180624.hanshin.1.html").read,
      "downloaded_timestamp" => Time.utc(2018, 6, 24, 0, 0, 0)}

    @parser = InvestmentHorseRacing::Crawler::Parser::EntryPageParser.new(url, data)

    # error page parser
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
  end

  describe "#valid?" do
    context "2018-06-24 hanshin no 1 race entry page" do
      it "is valid" do
        expect(@parser).to be_valid
      end
    end

    context "error page" do
      it "is invalid" do
        expect(@parser_error).not_to be_valid
      end
    end
  end

  describe "#related_links" do
    context "2018-06-24 hanshin no 1 race entry page" do
      it "is horse, jocky, trainer pages" do
        expect(@parser.related_links).to contain_exactly(
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
  end

  describe "#parse" do
    context "2018-06-24 hanshin no 1 race entry page" do
      it "is entry info" do
        context = {}

        @parser.parse(context)

        # TODO: Parse all result info
        expect(context).to match(
          "entries" => {
            "1809030801" => {
              "entry_id" => "1809030801",
              "race_number" => 1,
              "start_datetime" => Time.new(2018, 6, 24, 10, 5, 0),
              "race_name" => "サラ系3歳未勝利"
            }
          })
      end
    end
  end
end
