require "timecop"

require "spec_helper"

RSpec.describe ScoringHorseRacing::Parser::HorsePageParser do
  before do
    # "monte-ruth" horse page parser
    url = "https://keiba.yahoo.co.jp/directory/horse/2015103590/"
    data = {
      "url" => "https://keiba.yahoo.co.jp/directory/horse/2015103590/",
      "request_method" => "GET",
      "request_headers" => {},
      "response_headers" => {},
      "response_body" => File.open("spec/data/horse.2015103590.html").read,
      "downloaded_timestamp" => Time.now}

    @parser = ScoringHorseRacing::Parser::HorsePageParser.new(url, data)

    # error page parser
    url = "https://keiba.yahoo.co.jp/directory/horse/0000000000/"
    data = {
      "url" => "https://keiba.yahoo.co.jp/directory/horse/0000000000/",
      "request_method" => "GET",
      "request_headers" => {},
      "response_headers" => {},
      "response_body" => File.open("spec/data/horse.0000000000.html").read,
      "downloaded_timestamp" => Time.now}

    @parser_error = ScoringHorseRacing::Parser::HorsePageParser.new(url, data)
  end

  describe "#redownload?" do
    context "within 1 month from last download" do
      it "do not redownload" do
        Timecop.freeze(Time.local(2018, 7, 24)) do
          expect(@parser).not_to be_redownload
        end
      end
    end

    context "1 month or more after the last download" do
      it "redownload" do
        # TODO: #6761 temporarily implement so as not to redownload
        Timecop.freeze(Time.local(2018, 7, 25)) do
          expect(@parser).not_to be_redownload
        end
      end
    end
  end

  describe "#valid?" do
    context "monte-ruth horse page" do
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
    it "is trainer page" do
      expect(@parser.related_links).to contain_exactly(
        "https://keiba.yahoo.co.jp/directory/trainer/01157/")
    end
  end

  describe "#parse" do
    it "is horse info" do
      context = {}

      @parser.parse(context)

      # TODO: Parse all horse info
      expect(context).to match(
        "horses" => {
          "2015103590" => {
            "horse_id" => "2015103590",
            "gender" => "牝",
            "name" => "モンテルース",
            "date_of_birth" => Time.local(2015, 3, 12),
            "coat_color" => "黒鹿毛",
            "trainer_id" => "01157",
            "owner" => "有限会社 高昭牧場",
            "breeder" => "高昭牧場",
            "breeding_center" => "浦河町"
          }
        }
      )
    end
  end
end
