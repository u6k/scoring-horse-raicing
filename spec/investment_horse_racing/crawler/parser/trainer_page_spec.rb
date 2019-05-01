require "timecop"
require "webmock/rspec"

require "spec_helper"

RSpec.describe InvestmentHorseRacing::Crawler::Parser::TrainerPageParser do
  before do
    WebMock.enable!

    @downloader = Crawline::Downloader.new("investment-horse-racing-crawler/#{InvestmentHorseRacing::Crawler::VERSION}")

    # "haruki-sugiyama" trainer page parser
    @url = "https://keiba.yahoo.co.jp/directory/trainer/01157/"
    WebMock.stub_request(:get, @url).to_return(
      status: [200, "OK"],
      body: File.open("spec/data/trainer.01157.html").read)

    @parser = InvestmentHorseRacing::Crawler::Parser::TrainerPageParser.new(@url, @downloader.download_with_get(@url))

    # error page parser
    @url_error = "https://keiba.yahoo.co.jp/directory/trainer/00000/"
    WebMock.stub_request(:get, @url_error).to_return(
      status: [200, "OK"],
      body: File.open("spec/data/trainer.00000.html").read)

    @parser_error = InvestmentHorseRacing::Crawler::Parser::TrainerPageParser.new(@url_error, @downloader.download_with_get(@url_error))

    WebMock.disable!
  end

  describe "#redownload?" do
    it "do not redownload always" do
      expect(@parser).not_to be_redownload
    end
  end

  describe "#valid?" do
    context "haruki-sugiyama trainer page" do
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
    context "local data" do
      it "is trainer info" do
        context = {}

        @parser.parse(context)

        # TODO: Parse all jockey info
        expect(context).to match(
          "trainers" => {
            "01157" => {
              "trainer_id" => "01157",
              "name" => "杉山 晴紀",
              "name_kana" => "スギヤマ ハルキ",
              "date_of_birth" => Time.local(1981, 12, 24),
              "affiliation" => "栗東"
            }
          })
      end
    end

    context "valid page on web" do
      it "parse success" do
        parser = InvestmentHorseRacing::Crawler::Parser::TrainerPageParser.new(@url, @downloader.download_with_get(@url))

        context = {}
        @parser.parse(context)

        expect(context).to match(
          "trainers" => {
            "01157" => {
              "trainer_id" => "01157",
              "name" => "杉山 晴紀",
              "name_kana" => "スギヤマ ハルキ",
              "date_of_birth" => Time.local(1981, 12, 24),
              "affiliation" => "栗東"
            }
          })
      end
    end
  end
end
