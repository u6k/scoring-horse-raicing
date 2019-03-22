require "timecop"

require "spec_helper"

RSpec.describe ScoringHorseRacing::Parser::OddsQuinellaPageParser do
  before do
    # 2018-06-24 hanshin 1R odds quinella page parser
    url = "https://keiba.yahoo.co.jp/odds/ur/1809030801/"
    data = {
      "url" => "https://keiba.yahoo.co.jp/odds/ur/1809030801/",
      "request_method" => "GET",
      "request_headers" => {},
      "response_headers" => {},
      "response_body" => File.open("spec/data/odds_quinella.20180624.hanshin.1.html"),
      "downloaded_timestamp" => Time.utc(2018, 6, 24, 0, 0, 0)}

    @parser = ScoringHorseRacing::Parser::OddsQuinellaPageParser.new(url, data)

    # error page parser
    url = "https://keiba.yahoo.co.jp/odds/ur/0000000000/"
    data = {
      "url" => "https://keiba.yahoo.co.jp/odds/ur/0000000000/",
      "request_method" => "GET",
      "request_headers" => {},
      "response_headers" => {},
      "response_body" => File.open("spec/data/odds_quinella.00000000.error.html"),
      "downloaded_timestamp" => Time.now}

    @parser_error = ScoringHorseRacing::Parser::OddsQuinellaPageParser.new(url, data)
  end

  describe "#redownload?" do
    context "2018-06-24 hanshin 1R odds quinella page" do
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
    context "2018-06-24 hanshin 1R odds quinella page" do
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
    context "2018-06-24 hanshin 1R odds quinella page" do
      it "is odds pages" do
        expect(@parser.related_links).to contain_exactly(
          "https://keiba.yahoo.co.jp/odds/tfw/1809030801/",
          "https://keiba.yahoo.co.jp/odds/wide/1809030801/",
          "https://keiba.yahoo.co.jp/odds/ut/1809030801/",
          "https://keiba.yahoo.co.jp/odds/sf/1809030801/",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/")
      end
    end
  end

  describe "#parse" do
    context "2018-06-24 hanshin 1R odds quinella page" do
      it "is odds quinella info" do
        context = {}

        @parser.parse(context)

        # TODO: Parse all odds exacta info
        expect(context).to match(
          "odds_quinella" => {
            "1809030801" => {}
          }
        )
      end
    end
  end
end
