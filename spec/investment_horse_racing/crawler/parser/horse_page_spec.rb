require "timecop"
require "webmock/rspec"

require "spec_helper"

RSpec.describe InvestmentHorseRacing::Crawler::Parser::HorsePageParser do
  before do
    WebMock.enable!

    @downloader = Crawline::Downloader.new("investment-horse-racing-crawler/#{InvestmentHorseRacing::Crawler::VERSION}")

    # "monte-ruth" horse page parser
    @url = "https://keiba.yahoo.co.jp/directory/horse/2015103590/"
    WebMock.stub_request(:get, @url).to_return(
      status: [200, "OK"],
      body: File.open("spec/data/horse.2015103590.html").read)

    @parser = InvestmentHorseRacing::Crawler::Parser::HorsePageParser.new(@url, @downloader.download_with_get(@url))

    # error page parser
    @url_error = "https://keiba.yahoo.co.jp/directory/horse/0000000000/"
    WebMock.stub_request(:get, @url_error).to_return(
      status: [200, "OK"],
      body: File.open("spec/data/horse.0000000000.html").read)

    @parser_error = InvestmentHorseRacing::Crawler::Parser::HorsePageParser.new(@url_error, @downloader.download_with_get(@url_error))

    WebMock.disable!
  end

  describe "#redownload?" do
    it "do not redownload always" do
      expect(@parser).not_to be_redownload
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
    context "local data" do
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

    context "valid page on web" do
      it "parse success" do
        parser = InvestmentHorseRacing::Crawler::Parser::HorsePageParser.new(@url, @downloader.download_with_get(@url))

        context = {}
        parser.parse(context)

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
end
