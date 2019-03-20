require "timecop"

require "spec_helper"

RSpec.describe ScoringHorseRacing::Parser::OddsTrifectaPageParser do
  before do
    # 2018-06-24 hanshin 1R umaBan 1 odds trifecta page parser
    url = "https://keiba.yahoo.co.jp/odds/st/1809030801/"
    data = {
      "url" => "https://keiba.yahoo.co.jp/odds/st/1809030801/",
      "request_method" => "GET",
      "request_headers" => {},
      "response_headers" => {},
      "response_body" => File.open("spec/data/odds_trifecta.20180624.hanshin.1.1.html"),
      "downloaded_timestamp" => Time.now}

    @parser = ScoringHorseRacing::Parser::OddsTrifectaPageParser.new(url, data)

    # 2018-06-24 hanshin 1R umaBan 16 odds trifecta page parser
    url = "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=16"
    data = {
      "url" => "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=16",
      "request_method" => "GET",
      "request_headers" => {},
      "response_headers" => {},
      "response_body" => File.open("spec/data/odds_trifecta.20180624.hanshin.1.16.html"),
      "downloaded_timestamp" => Time.now}

    @parser_16 = ScoringHorseRacing::Parser::OddsTrifectaPageParser.new(url, data)

    # error page parser
    url = "https://keiba.yahoo.co.jp/odds/st/0000000000/"
    data = {
      "url" => "https://keiba.yahoo.co.jp/odds/st/0000000000/",
      "request_method" => "GET",
      "request_headers" => {},
      "response_headers" => {},
      "response_body" => File.open("spec/data/odds_trifecta.00000000.error.html"),
      "downloaded_timestamp" => Time.now}

    @parser_error = ScoringHorseRacing::Parser::OddsTrifectaPageParser.new(url, data)
  end

  describe "#redownload?" do
    context "2018-06-24 hanshin 1R umaBan 1 odds trifecta page" do
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
    end

    context "2018-06-24 hanshin 1R umaBan 16 odds trifecta page" do
      it "redownload if newer than 2 months" do
        Timecop.freeze(Time.local(2018, 9, 21)) do
          expect(@parser_16).to be_redownload
        end
      end

      it "do not redownload if over 3 months old" do
        Timecop.freeze(Time.local(2018, 9, 22)) do
          expect(@parser_16).not_to be_redownload
        end
      end
    end
  end

  describe "#valid?" do
    context "2018-06-24 hanshin 1R umaBan 1 odds trifecta page" do
      it "is valid" do
        expect(@parser).to be_valid
      end
    end

    context "2018-06-24 hanshin 1R umaBan 16 odds trifecta page" do
      it "is valid" do
        expect(@parser_16).to be_valid
      end
    end

    context "error page" do
      it "is invalid" do
        expect(@parser_error).not_to be_valid
      end
    end
  end

  describe "#related_links" do
    context "2018-06-24 hanshin 1R umaBan 1 odds trifecta page" do
      it "is odds pages" do
        expect(@parser.related_links).to contain_exactly(
          "https://keiba.yahoo.co.jp/odds/tfw/1809030801/",
          "https://keiba.yahoo.co.jp/odds/ur/1809030801/",
          "https://keiba.yahoo.co.jp/odds/wide/1809030801/",
          "https://keiba.yahoo.co.jp/odds/ut/1809030801/",
          "https://keiba.yahoo.co.jp/odds/sf/1809030801/",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=2",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=3",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=4",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=5",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=6",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=7",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=8",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=9",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=10",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=11",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=12",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=13",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=14",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=15",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=16")
      end
    end

    context "2018-06-24 hanshin 1R umaBan 16 odds trifecta page" do
      it "is odds pages" do
        expect(@parser_16.related_links).to contain_exactly(
          "https://keiba.yahoo.co.jp/odds/tfw/1809030801/",
          "https://keiba.yahoo.co.jp/odds/ur/1809030801/",
          "https://keiba.yahoo.co.jp/odds/wide/1809030801/",
          "https://keiba.yahoo.co.jp/odds/ut/1809030801/",
          "https://keiba.yahoo.co.jp/odds/sf/1809030801/",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=1",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=2",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=3",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=4",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=5",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=6",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=7",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=8",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=9",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=10",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=11",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=12",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=13",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=14",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=15")
      end
    end
  end

  describe "#parse" do
    context "2018-06-24 hanshin 1R umaBan 1 odds trifecta page" do
      it "is odds trifecta info" do
        context = {}

        @parser.parse(context)

        # TODO: Parse all odds trifecta info
        expect(context).to match(
          "odds_trifecta" => {
            "1809030801" => {
              "1" => {}
            }
          }
        )
      end
    end

    context "2018-06-24 hanshin 1R umaBan 16 odds trifecta page" do
      it "is odds trifecta info" do
        context = {}

        @parser_16.parse(context)

        # TODO: Parse all odds trifecta info
        expect(context).to match(
          "odds_trifecta" => {
            "1809030801" => {
              "16" => {}
            }
          }
        )
      end
    end
  end
end
