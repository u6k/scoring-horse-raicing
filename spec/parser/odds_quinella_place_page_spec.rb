require "timecop"

require "spec_helper"

RSpec.describe ScoringHorseRacing::Parser::OddsQuinellaPlacePageParser do
  before do
    # 2018-06-24 hanshin 1R odds quinella place page parser
    url = "https://keiba.yahoo.co.jp/odds/wide/1809030801/"
    data = File.open("spec/data/odds_quinella_place.20180624.hanshin.1.html")

    @parser = ScoringHorseRacing::Parser::OddsQuinellaPlacePageParser.new(url, data)

    # error page parser
    url = "https://keiba.yahoo.co.jp/odds/wide/0000000000/"
    data = File.open("spec/data/odds_quinella_place.00000000.error.html")

    @parser_error = ScoringHorseRacing::Parser::OddsQuinellaPlacePageParser.new(url, data)
  end

  describe "#redownload?" do
    context "2018-06-24 hanshin 1R odds quinella place page" do
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
  end

  describe "#valid?" do
    context "2018-06-24 hanshin 1R odds quinella place page" do
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
    context "2018-06-24 hanshin 1R odds quinella place page" do
      it "is odds pages" do
        expect(@parser.related_links).to contain_exactly(
          "https://keiba.yahoo.co.jp/odds/tfw/1809030801/",
          "https://keiba.yahoo.co.jp/odds/ur/1809030801/",
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
          "odds_quinella_place" => {
            "1809030801" => {}
          }
        )
      end
    end
  end
end
