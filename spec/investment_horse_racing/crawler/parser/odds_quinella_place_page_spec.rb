require "timecop"
require "webmock/rspec"

require "spec_helper"

RSpec.describe InvestmentHorseRacing::Crawler::Parser::OddsQuinellaPlacePageParser do
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

    ## 2018-06-24 hanshin 1R odds quinella place page parser
    @url = "https://keiba.yahoo.co.jp/odds/wide/1809030801/"
    WebMock.stub_request(:get, @url).to_return(
      status: [200, "OK"],
      body: File.open("spec/data/odds_quinella_place.20180624.hanshin.1.html").read)

    @parser = InvestmentHorseRacing::Crawler::Parser::OddsQuinellaPlacePageParser.new(@url, @downloader.download_with_get(@url))

    WebMock.disable!
  end

  describe "#redownload?" do
    context "2018-06-24 hanshin 1R odds quinella place page" do
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

        expect(context).to be_empty

        expected = build_expected

        expect(InvestmentHorseRacing::Crawler::Model::OddsQuinellaPlace.all).to match_array(expected)
      end

      it "overwrite when existing data" do
        meta_11111 = InvestmentHorseRacing::Crawler::Model::RaceMeta.create(race_id: "11111")
        meta_22222 = InvestmentHorseRacing::Crawler::Model::RaceMeta.create(race_id: "22222")

        InvestmentHorseRacing::Crawler::Model::OddsQuinellaPlace.create(race_meta: meta_11111, horse_number_1: 1, horse_number_2: 1, odds_1: 111.11, odds_2: 111.11)
        InvestmentHorseRacing::Crawler::Model::OddsQuinellaPlace.create(race_meta: meta_22222, horse_number_1: 2, horse_number_2: 2, odds_1: 222.22, odds_2: 222.22)
        InvestmentHorseRacing::Crawler::Model::OddsQuinellaPlace.create(race_meta: @meta,      horse_number_1: 3, horse_number_2: 3, odds_1: 333.33, odds_2: 333.33)

        context = {}

        @parser.parse(context)

        expect(context).to be_empty

        expected = build_expected
        expected << have_attributes(race_meta_id: meta_11111.id, horse_number_1: 1, horse_number_2: 1, odds_1: 111.11, odds_2: 111.11)
        expected << have_attributes(race_meta_id: meta_22222.id, horse_number_1: 2, horse_number_2: 2, odds_1: 222.22, odds_2: 222.22)

        expect(InvestmentHorseRacing::Crawler::Model::OddsQuinellaPlace.all).to match_array(expected)
      end
    end

    context "valid page on web" do
      it "parse success" do
        parser = InvestmentHorseRacing::Crawler::Parser::OddsQuinellaPlacePageParser.new(@url, @downloader.download_with_get(@url))

        context = {}

        parser.parse(context)

        expect(context).to be_empty

        expect(InvestmentHorseRacing::Crawler::Model::OddsQuinellaPlace.count).to be > 0
      end
    end

    def build_expected
      [
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 2, odds_1: 16.1, odds_2: 17.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 3, odds_1: 17.4, odds_2: 19.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 4, odds_1: 11.0, odds_2: 12.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 5, odds_1: 26.1, odds_2: 28.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 6, odds_1: 34.6, odds_2: 37.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 7, odds_1: 57.9, odds_2: 62.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 8, odds_1: 20.6, odds_2: 22.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 9, odds_1: 17.8, odds_2: 19.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 10, odds_1: 87.2, odds_2: 94.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 11, odds_1: 307.8, odds_2: 330.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 12, odds_1: 7.3, odds_2: 8.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 13, odds_1: 193.9, odds_2: 208.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 14, odds_1: 3.7, odds_2: 4.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 15, odds_1: 17.3, odds_2: 19.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 16, odds_1: 126.2, odds_2: 136.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 3, odds_1: 36.7, odds_2: 38.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 4, odds_1: 27.7, odds_2: 29.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 5, odds_1: 45.5, odds_2: 47.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 6, odds_1: 63.8, odds_2: 66.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 7, odds_1: 200.6, odds_2: 206.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 8, odds_1: 48.5, odds_2: 51.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 9, odds_1: 41.1, odds_2: 43.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 10, odds_1: 210.4, odds_2: 216.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 11, odds_1: 701.5, odds_2: 717.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 12, odds_1: 15.0, odds_2: 17.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 13, odds_1: 364.1, odds_2: 373.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 14, odds_1: 10.6, odds_2: 12.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 15, odds_1: 46.0, odds_2: 48.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 16, odds_1: 220.3, odds_2: 226.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 4, odds_1: 23.5, odds_2: 25.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 5, odds_1: 40.4, odds_2: 42.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 6, odds_1: 70.3, odds_2: 73.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 7, odds_1: 91.3, odds_2: 94.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 8, odds_1: 40.4, odds_2: 42.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 9, odds_1: 29.5, odds_2: 31.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 10, odds_1: 131.3, odds_2: 135.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 11, odds_1: 631.0, odds_2: 648.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 12, odds_1: 13.7, odds_2: 15.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 13, odds_1: 142.3, odds_2: 146.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 14, odds_1: 8.7, odds_2: 9.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 15, odds_1: 26.8, odds_2: 28.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 16, odds_1: 214.4, odds_2: 221.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 5, odds_1: 19.9, odds_2: 21.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 6, odds_1: 34.7, odds_2: 36.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 7, odds_1: 46.7, odds_2: 49.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 8, odds_1: 18.9, odds_2: 20.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 9, odds_1: 21.2, odds_2: 23.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 10, odds_1: 62.6, odds_2: 65.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 11, odds_1: 527.0, odds_2: 551.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 12, odds_1: 6.7, odds_2: 7.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 13, odds_1: 170.5, odds_2: 179.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 14, odds_1: 5.3, odds_2: 6.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 15, odds_1: 22.3, odds_2: 24.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 16, odds_1: 137.3, odds_2: 144.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 6, odds_1: 46.7, odds_2: 48.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 7, odds_1: 191.9, odds_2: 197.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 8, odds_1: 38.9, odds_2: 40.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 9, odds_1: 34.3, odds_2: 36.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 10, odds_1: 135.7, odds_2: 139.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 11, odds_1: 248.3, odds_2: 253.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 12, odds_1: 15.8, odds_2: 18.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 13, odds_1: 371.0, odds_2: 380.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 14, odds_1: 10.7, odds_2: 12.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 15, odds_1: 38.6, odds_2: 40.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 16, odds_1: 248.4, odds_2: 254.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 7, odds_1: 183.2, odds_2: 186.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 8, odds_1: 44.1, odds_2: 46.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 9, odds_1: 60.9, odds_2: 64.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 10, odds_1: 139.2, odds_2: 141.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 11, odds_1: 246.2, odds_2: 249.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 12, odds_1: 22.3, odds_2: 25.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 13, odds_1: 405.5, odds_2: 412.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 14, odds_1: 16.4, odds_2: 18.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 15, odds_1: 52.6, odds_2: 55.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 16, odds_1: 326.6, odds_2: 332.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 8, odds_1: 182.4, odds_2: 188.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 9, odds_1: 155.3, odds_2: 161.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 10, odds_1: 174.4, odds_2: 176.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 11, odds_1: 616.2, odds_2: 619.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 12, odds_1: 54.9, odds_2: 61.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 13, odds_1: 274.3, odds_2: 276.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 14, odds_1: 47.4, odds_2: 53.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 15, odds_1: 79.4, odds_2: 82.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 16, odds_1: 510.4, odds_2: 514.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 9, odds_1: 34.5, odds_2: 36.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 10, odds_1: 119.4, odds_2: 123.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 11, odds_1: 853.4, odds_2: 877.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 12, odds_1: 12.2, odds_2: 14.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 13, odds_1: 363.3, odds_2: 374.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 14, odds_1: 8.7, odds_2: 9.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 15, odds_1: 32.6, odds_2: 34.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 16, odds_1: 202.0, odds_2: 208.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 10, odds_1: 173.7, odds_2: 181.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 11, odds_1: 235.0, odds_2: 243.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 12, odds_1: 11.6, odds_2: 13.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 13, odds_1: 328.0, odds_2: 340.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 14, odds_1: 6.8, odds_2: 7.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 15, odds_1: 30.0, odds_2: 32.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 16, odds_1: 185.1, odds_2: 192.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 11, odds_1: 1092.5, odds_2: 1099.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 12, odds_1: 51.9, odds_2: 58.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 13, odds_1: 676.2, odds_2: 681.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 14, odds_1: 41.8, odds_2: 46.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 15, odds_1: 147.9, odds_2: 153.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 16, odds_1: 433.3, odds_2: 437.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 12, odds_1: 353.7, odds_2: 395.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 13, odds_1: 957.3, odds_2: 960.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 14, odds_1: 248.3, odds_2: 277.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 15, odds_1: 570.7, odds_2: 589.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 16, odds_1: 933.8, odds_2: 938.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 13, odds_1: 101.4, odds_2: 113.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 14, odds_1: 2.6, odds_2: 2.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 15, odds_1: 12.6, odds_2: 14.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 16, odds_1: 65.2, odds_2: 73.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 13, horse_number_2: 14, odds_1: 75.4, odds_2: 84.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 13, horse_number_2: 15, odds_1: 237.9, odds_2: 246.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 13, horse_number_2: 16, odds_1: 608.9, odds_2: 613.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 14, horse_number_2: 15, odds_1: 7.6, odds_2: 8.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 14, horse_number_2: 16, odds_1: 50.3, odds_2: 56.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 15, horse_number_2: 16, odds_1: 170.1, odds_2: 176.4),
      ]
    end
  end
end
