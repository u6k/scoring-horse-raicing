require "timecop"

require "spec_helper"

RSpec.describe ScoringHorseRacing::Parser::JockeyPageParser do
  before do
    # "keita-tosaki" jockey page parser
    url = "https://keiba.yahoo.co.jp/directory/jocky/05386/"
    data = {
      "url" => "https://keiba.yahoo.co.jp/directory/jocky/05386/",
      "request_method" => "GET",
      "request_headers" => {},
      "response_headers" => {},
      "response_body" => File.open("spec/data/jockey.05386.html").read,
      "downloaded_timestamp" => Time.now}

    @parser = ScoringHorseRacing::Parser::JockeyPageParser.new(url, data)

    # error page parser
    url = "https://keiba.yahoo.co.jp/directory/jocky/00000/"
    data = {
      "url" => "https://keiba.yahoo.co.jp/directory/jocky/00000/",
      "request_method" => "GET",
      "request_headers" => {},
      "response_headers" => {},
      "response_body" => File.open("spec/data/jockey.00000.html").read,
      "downloaded_timestamp" => Time.now}

    @parser_error = ScoringHorseRacing::Parser::JockeyPageParser.new(url, data)
  end

  describe "#redownload?" do
    context "within 1 month from last download" do
      it "do not redownload" do
        Timecop.freeze(Time.local(2018, 7, 24)) do
          expect(@parser).not_to be_redownload
        end
      end
    end

    context "1 month or more after last download" do
      it "redownload" do
        # TODO: #6761 temporarily implement so as not to redownload
        Timecop.freeze(Time.local(2018, 7, 25)) do
          expect(@parser).not_to be_redownload
        end
      end
    end
  end

  describe "#valid?" do
    context "keita-tosaki jockey page" do
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
    it "is empty" do
      expect(@parser.related_links).to be_empty
    end
  end

  describe "#parse" do
    it "is jockey info" do
      context = {}

      @parser.parse(context)

      # TODO: Parse all jockey info
      expect(context).to match(
        "jockeys" => {
          "05386" => {
            "jockey_id" => "05386",
            "name" => "戸崎 圭太",
            "name_kana" => "トサキ ケイタ",
            "date_of_birth" => Time.local(1980, 7, 8),
            "affiliation" => "美浦(田島 俊明)"
          }
        })
    end
  end
end
