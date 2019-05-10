require "timecop"
require "webmock/rspec"

require "spec_helper"

RSpec.describe InvestmentHorseRacing::Crawler::Parser::OddsQuinellaPageParser do
  before do
    WebMock.enable!

    @downloader = Crawline::Downloader.new("investment-horse-racing-crawler/#{InvestmentHorseRacing::Crawler::VERSION}")

    # Setup data
    InvestmentHorseRacing::Crawler::Model::RaceMeta.destroy_all

    ## 2018-06-24 hanshin no 1 race result data
    url = "https://keiba.yahoo.co.jp/race/result/1809030801/"
    WebMock.stub_request(:get, url).to_return(
      status: [200, "OK"],
      body: File.open("spec/data/result.20180624.hanshin.1.html").read)

    parser = InvestmentHorseRacing::Crawler::Parser::ResultPageParser.new(url, @downloader.download_with_get(url))
    parser.parse({})

    @meta = InvestmentHorseRacing::Crawler::Model::RaceMeta.find_by(race_id: "1809030801")

    ## 2018-06-24 hanshin 1R odds quinella page parser
    @url = "https://keiba.yahoo.co.jp/odds/ur/1809030801/"
    WebMock.stub_request(:get, @url).to_return(
      status: [200, "OK"],
      body: File.open("spec/data/odds_quinella.20180624.hanshin.1.html").read)

    @parser = InvestmentHorseRacing::Crawler::Parser::OddsQuinellaPageParser.new(@url, @downloader.download_with_get(@url))

    WebMock.disable!
  end

  describe "#redownload?" do
    context "2018-06-24 hanshin 1R odds quinella page" do
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

        expect(context).to be_empty

        expect(InvestmentHorseRacing::Crawler::Model::OddsQuinella.all).to match_array([
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 2, odds: 51.4),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 3, odds: 50.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 4, odds: 39.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 5, odds: 87.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 6, odds: 119.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 7, odds: 189.3),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 8, odds: 78.4),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 9, odds: 55.8),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 10, odds: 405.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 11, odds: 858.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 12, odds: 19.7),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 13, odds: 591.9),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 14, odds: 11.9),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 15, odds: 43.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 16, odds: 422.8),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 3, odds: 125.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 4, odds: 108.4),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 5, odds: 191.3),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 6, odds: 260.9),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 7, odds: 871.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 8, odds: 196.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 9, odds: 137.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 10, odds: 1172.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 11, odds: 2916.3),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 12, odds: 48.4),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 13, odds: 1968.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 14, odds: 26.0),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 15, odds: 130.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 16, odds: 1242.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 4, odds: 90.7),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 5, odds: 172.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 6, odds: 288.8),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 7, odds: 405.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 8, odds: 166.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 9, odds: 113.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 10, odds: 628.4),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 11, odds: 2657.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 12, odds: 43.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 13, odds: 656.9),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 14, odds: 26.9),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 15, odds: 83.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 16, odds: 1067.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 5, odds: 98.8),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 6, odds: 163.7),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 7, odds: 224.7),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 8, odds: 80.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 9, odds: 88.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 10, odds: 356.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 11, odds: 2061.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 12, odds: 21.8),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 13, odds: 749.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 14, odds: 15.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 15, odds: 80.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 16, odds: 614.7),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 6, odds: 250.9),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 7, odds: 855.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 8, odds: 173.4),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 9, odds: 161.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 10, odds: 1021.9),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 11, odds: 2898.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 12, odds: 55.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 13, odds: 2009.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 14, odds: 32.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 15, odds: 148.9),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 16, odds: 1296.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 7, odds: 1046.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 8, odds: 225.8),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 9, odds: 258.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 10, odds: 974.0),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 11, odds: 4087.8),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 12, odds: 85.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 13, odds: 2427.8),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 14, odds: 51.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 15, odds: 201.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 16, odds: 1626.8),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 8, odds: 839.0),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 9, odds: 580.4),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 10, odds: 848.0),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 11, odds: 4643.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 12, odds: 212.8),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 13, odds: 1861.0),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 14, odds: 144.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 15, odds: 277.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 16, odds: 3231.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 9, odds: 149.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 10, odds: 735.8),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 11, odds: 3209.9),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 12, odds: 42.7),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 13, odds: 1462.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 14, odds: 25.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 15, odds: 110.3),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 16, odds: 831.7),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 10, odds: 702.3),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 11, odds: 2001.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 12, odds: 34.0),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 13, odds: 1232.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 14, odds: 20.4),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 15, odds: 92.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 16, odds: 813.4),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 11, odds: 11387.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 12, odds: 236.7),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 13, odds: 5904.7),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 14, odds: 144.4),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 15, odds: 627.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 16, odds: 2813.4),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 12, odds: 1058.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 13, odds: 7246.7),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 14, odds: 658.7),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 15, odds: 1499.3),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 16, odds: 7591.7),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 13, odds: 382.9),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 14, odds: 6.0),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 15, odds: 30.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 16, odds: 263.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 13, horse_number_2: 14, odds: 257.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 13, horse_number_2: 15, odds: 660.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 13, horse_number_2: 16, odds: 4689.0),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 14, horse_number_2: 15, odds: 18.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 14, horse_number_2: 16, odds: 153.3),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 15, horse_number_2: 16, odds: 502.3),
        ])
      end

      it "overwrite when existing data" do
        meta_11111 = InvestmentHorseRacing::Crawler::Model::RaceMeta.create(race_id: "11111")
        meta_22222 = InvestmentHorseRacing::Crawler::Model::RaceMeta.create(race_id: "22222")

        InvestmentHorseRacing::Crawler::Model::OddsQuinella.create(race_meta: meta_11111, horse_number_1: 1, horse_number_2: 1, odds: 111.11)
        InvestmentHorseRacing::Crawler::Model::OddsQuinella.create(race_meta: meta_22222, horse_number_1: 2, horse_number_2: 2, odds: 222.22)
        InvestmentHorseRacing::Crawler::Model::OddsQuinella.create(race_meta: @meta,      horse_number_1: 3, horse_number_2: 3, odds: 333.33)

        context = {}

        @parser.parse(context)

        expect(context).to be_empty

        expect(InvestmentHorseRacing::Crawler::Model::OddsQuinella.all).to match_array([
          have_attributes(race_meta_id: meta_11111.id, horse_number_1: 1, horse_number_2: 1, odds: 111.11),
          have_attributes(race_meta_id: meta_22222.id, horse_number_1: 2, horse_number_2: 2, odds: 222.22),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 2, odds: 51.4),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 3, odds: 50.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 4, odds: 39.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 5, odds: 87.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 6, odds: 119.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 7, odds: 189.3),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 8, odds: 78.4),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 9, odds: 55.8),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 10, odds: 405.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 11, odds: 858.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 12, odds: 19.7),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 13, odds: 591.9),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 14, odds: 11.9),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 15, odds: 43.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 16, odds: 422.8),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 3, odds: 125.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 4, odds: 108.4),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 5, odds: 191.3),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 6, odds: 260.9),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 7, odds: 871.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 8, odds: 196.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 9, odds: 137.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 10, odds: 1172.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 11, odds: 2916.3),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 12, odds: 48.4),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 13, odds: 1968.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 14, odds: 26.0),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 15, odds: 130.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 16, odds: 1242.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 4, odds: 90.7),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 5, odds: 172.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 6, odds: 288.8),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 7, odds: 405.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 8, odds: 166.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 9, odds: 113.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 10, odds: 628.4),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 11, odds: 2657.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 12, odds: 43.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 13, odds: 656.9),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 14, odds: 26.9),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 15, odds: 83.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 16, odds: 1067.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 5, odds: 98.8),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 6, odds: 163.7),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 7, odds: 224.7),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 8, odds: 80.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 9, odds: 88.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 10, odds: 356.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 11, odds: 2061.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 12, odds: 21.8),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 13, odds: 749.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 14, odds: 15.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 15, odds: 80.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 16, odds: 614.7),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 6, odds: 250.9),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 7, odds: 855.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 8, odds: 173.4),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 9, odds: 161.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 10, odds: 1021.9),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 11, odds: 2898.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 12, odds: 55.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 13, odds: 2009.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 14, odds: 32.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 15, odds: 148.9),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 16, odds: 1296.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 7, odds: 1046.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 8, odds: 225.8),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 9, odds: 258.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 10, odds: 974.0),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 11, odds: 4087.8),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 12, odds: 85.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 13, odds: 2427.8),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 14, odds: 51.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 15, odds: 201.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 16, odds: 1626.8),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 8, odds: 839.0),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 9, odds: 580.4),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 10, odds: 848.0),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 11, odds: 4643.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 12, odds: 212.8),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 13, odds: 1861.0),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 14, odds: 144.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 15, odds: 277.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 16, odds: 3231.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 9, odds: 149.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 10, odds: 735.8),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 11, odds: 3209.9),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 12, odds: 42.7),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 13, odds: 1462.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 14, odds: 25.2),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 15, odds: 110.3),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 16, odds: 831.7),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 10, odds: 702.3),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 11, odds: 2001.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 12, odds: 34.0),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 13, odds: 1232.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 14, odds: 20.4),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 15, odds: 92.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 16, odds: 813.4),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 11, odds: 11387.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 12, odds: 236.7),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 13, odds: 5904.7),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 14, odds: 144.4),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 15, odds: 627.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 16, odds: 2813.4),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 12, odds: 1058.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 13, odds: 7246.7),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 14, odds: 658.7),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 15, odds: 1499.3),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 16, odds: 7591.7),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 13, odds: 382.9),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 14, odds: 6.0),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 15, odds: 30.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 16, odds: 263.5),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 13, horse_number_2: 14, odds: 257.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 13, horse_number_2: 15, odds: 660.6),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 13, horse_number_2: 16, odds: 4689.0),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 14, horse_number_2: 15, odds: 18.1),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 14, horse_number_2: 16, odds: 153.3),
          have_attributes(race_meta_id: @meta.id, horse_number_1: 15, horse_number_2: 16, odds: 502.3),
        ])
      end
    end

    context "valid page on web" do
      it "parse success" do
        parser = InvestmentHorseRacing::Crawler::Parser::OddsQuinellaPageParser.new(@url, @downloader.download_with_get(@url))

        context = {}

        parser.parse(context)

        expect(context).to be_empty

        expect(InvestmentHorseRacing::Crawler::Model::OddsQuinella.count).to be > 0
      end
    end
  end
end
