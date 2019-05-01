require "timecop"

require "spec_helper"

RSpec.describe InvestmentHorseRacing::Crawler::Parser::OddsExactaPageParser do
  before do
    # 2018-06-24 hanshin 1R odds exacta page parser
    url = "https://keiba.yahoo.co.jp/odds/ut/1809030801/"
    data = {
      "url" => "https://keiba.yahoo.co.jp/odds/ut/1809030801/",
      "request_method" => "GET",
      "request_headers" => {},
      "response_headers" => {},
      "response_body" => File.open("spec/data/odds_exacta.20180624.hanshin.1.html").read,
      "downloaded_timestamp" => Time.utc(2018, 6, 24, 0, 0, 0)}

    @parser = InvestmentHorseRacing::Crawler::Parser::OddsExactaPageParser.new(url, data)

    # error page parser
    url = "https://keiba.yahoo.co.jp/odds/ut/0000000000/"
    data = {
      "url" => "https://keiba.yahoo.co.jp/odds/ut/0000000000/",
      "request_method" => "GET",
      "request_headers" => {},
      "response_headers" => {},
      "response_body" => File.open("spec/data/odds_exacta.00000000.error.html").read,
      "downloaded_timestamp" => Time.now}

    @parser_error = InvestmentHorseRacing::Crawler::Parser::OddsExactaPageParser.new(url, data)
  end

  describe "#redownload?" do
    context "2018-06-24 hanshin 1R odds exacta page" do
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

  describe "#valid?" do
    context "2018-06-24 hanshin 1R odds exacta page" do
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
    context "2018-06-24 hanshin 1R odds exacta page" do
      it "is odds pages" do
        expect(@parser.related_links).to contain_exactly(
          "https://keiba.yahoo.co.jp/odds/tfw/1809030801/",
          "https://keiba.yahoo.co.jp/odds/ur/1809030801/",
          "https://keiba.yahoo.co.jp/odds/wide/1809030801/",
          "https://keiba.yahoo.co.jp/odds/sf/1809030801/",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/")
      end
    end
  end

  describe "#parse" do
    context "2018-06-24 hanshin 1R odds exacta page" do
      it "is odds exacta info" do
        context = {}

        @parser.parse(context)

        # TODO: Parse all odds exacta info
        expect(context).to match(
          "odds_exacta" => {
            "1809030801" => {}
          }
        )
      end
    end
  end
end
