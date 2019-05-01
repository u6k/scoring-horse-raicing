require "timecop"
require "webmock/rspec"

require "spec_helper"

RSpec.describe InvestmentHorseRacing::Crawler::Parser::RaceListPageParser do
  before do
    WebMock.enable!

    @downloader = Crawline::Downloader.new("investment-horse-racing-crawler/#{InvestmentHorseRacing::Crawler::VERSION}")

    # 2018-06-24 hanshin race list page parser
    @url = "https://keiba.yahoo.co.jp/race/list/18090308/"
    WebMock.stub_request(:get, @url).to_return(
      status: [200, "OK"],
      body: File.open("spec/data/race_list.20180624.hanshin.html").read)

    @parser = InvestmentHorseRacing::Crawler::Parser::RaceListPageParser.new(@url, @downloader.download_with_get(@url))

    # error page parser
    @url_error = "https://keiba.yahoo.co.jp/race/list/00000000/"
    WebMock.stub_request(:get, @url_error).to_return(
      status: [200, "OK"],
      body: File.open("spec/data/race_list.00000000.error.html").read)

    @parser_error = InvestmentHorseRacing::Crawler::Parser::RaceListPageParser.new(@url_error, @downloader.download_with_get(@url_error))

    WebMock.disable!
  end

  describe "#redownload?" do
    context "2018-06-24 hanshin race list page" do
      it "redownload if newer than 90 days" do
        Timecop.freeze(Time.local(2018, 9, 21, 23, 59, 59)) do
          expect(@parser).to be_redownload
        end
      end

      it "do not redownload if over 90 days old" do
        Timecop.freeze(Time.local(2018, 9, 22, 0, 0, 0)) do
          expect(@parser).not_to be_redownload
        end
      end
    end
  end

  describe "#valid?" do
    context "2018-06-24 hanshin race list page" do
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
    context "2018-06-24 hanshin race list page" do
      it "is result pages" do
        expect(@parser.related_links).to contain_exactly(
          "https://keiba.yahoo.co.jp/race/result/1809030801/",
          "https://keiba.yahoo.co.jp/race/result/1809030802/",
          "https://keiba.yahoo.co.jp/race/result/1809030803/",
          "https://keiba.yahoo.co.jp/race/result/1809030804/",
          "https://keiba.yahoo.co.jp/race/result/1809030805/",
          "https://keiba.yahoo.co.jp/race/result/1809030806/",
          "https://keiba.yahoo.co.jp/race/result/1809030807/",
          "https://keiba.yahoo.co.jp/race/result/1809030808/",
          "https://keiba.yahoo.co.jp/race/result/1809030809/",
          "https://keiba.yahoo.co.jp/race/result/1809030810/",
          "https://keiba.yahoo.co.jp/race/result/1809030811/",
          "https://keiba.yahoo.co.jp/race/result/1809030812/")
      end
    end
  end

  describe "#parse" do
    context "2018-06-24 hanshin race list page" do
      it "is race info" do
        context = {}

        @parser.parse(context)

        expect(context).to be_empty
      end
    end

    context "valid page on web" do
      it "parse success" do
        parser = InvestmentHorseRacing::Crawler::Parser::RaceListPageParser.new(@url, @downloader.download_with_get(@url))

        context = {}
        parser.parse(context)

        expect(context).to be_empty
      end
    end
  end
end
