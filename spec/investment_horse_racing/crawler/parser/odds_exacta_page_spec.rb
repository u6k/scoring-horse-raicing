require "timecop"
require "webmock/rspec"

require "spec_helper"

RSpec.describe InvestmentHorseRacing::Crawler::Parser::OddsExactaPageParser do
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

    ## 2018-06-24 hanshin 1R odds exacta page parser
    @url = "https://keiba.yahoo.co.jp/odds/ut/1809030801/"
    WebMock.stub_request(:get, @url).to_return(
      status: [200, "OK"],
      body: File.open("spec/data/odds_exacta.20180624.hanshin.1.html").read)

    @parser = InvestmentHorseRacing::Crawler::Parser::OddsExactaPageParser.new(@url, @downloader.download_with_get(@url))

    WebMock.disable!
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

        expect(context).to be_empty

        expected = build_expected

        expect(InvestmentHorseRacing::Crawler::Model::OddsExacta.all).to match_array(expected)
      end

      it "overwrite when existing data" do
        meta_11111 = InvestmentHorseRacing::Crawler::Model::RaceMeta.create(race_id: "11111")
        meta_22222 = InvestmentHorseRacing::Crawler::Model::RaceMeta.create(race_id: "22222")

        InvestmentHorseRacing::Crawler::Model::OddsExacta.create(race_meta: meta_11111, horse_number_1: 1, horse_number_2: 1, odds: 111.11)
        InvestmentHorseRacing::Crawler::Model::OddsExacta.create(race_meta: meta_22222, horse_number_1: 2, horse_number_2: 2, odds: 222.22)
        InvestmentHorseRacing::Crawler::Model::OddsExacta.create(race_meta: @meta,      horse_number_1: 3, horse_number_2: 3, odds: 333.33)

        context = {}

        @parser.parse(context)

        expect(context).to be_empty

        expected = build_expected
        expected << have_attributes(race_meta_id: meta_11111.id, horse_number_1: 1, horse_number_2: 1, odds: 111.11)
        expected << have_attributes(race_meta_id: meta_22222.id, horse_number_1: 2, horse_number_2: 2, odds: 222.22)

        expect(InvestmentHorseRacing::Crawler::Model::OddsExacta.all).to match_array(expected)
      end
    end

    context "valid page on web" do
      it "parse success" do
        parser = InvestmentHorseRacing::Crawler::Parser::OddsExactaPageParser.new(@url, @downloader.download_with_get(@url))

        context = {}

        parser.parse(context)

        expect(context).to be_empty

        expect(InvestmentHorseRacing::Crawler::Model::OddsExacta.count).to be > 0
      end
    end

    def build_expected
      [
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 2, odds: 85.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 3, odds: 97.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 4, odds: 71.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 5, odds: 143.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 6, odds: 211.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 7, odds: 411.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 8, odds: 140.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 9, odds: 99.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 10, odds: 496.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 11, odds: 1481.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 12, odds: 42.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 13, odds: 969.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 14, odds: 26.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 15, odds: 75.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 16, odds: 515.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 1, odds: 112.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 3, odds: 258.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 4, odds: 258.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 5, odds: 391.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 6, odds: 503.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 7, odds: 939.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 8, odds: 365.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 9, odds: 247.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 10, odds: 1748.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 11, odds: 2770.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 12, odds: 100.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 13, odds: 3951.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 14, odds: 67.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 15, odds: 229.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 2, horse_number_2: 16, odds: 1734.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 1, odds: 112.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 2, odds: 277.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 4, odds: 193.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 5, odds: 324.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 6, odds: 522.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 7, odds: 874.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 8, odds: 371.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 9, odds: 285.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 10, odds: 969.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 11, odds: 4539.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 12, odds: 105.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 13, odds: 1172.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 14, odds: 70.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 15, odds: 153.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 3, horse_number_2: 16, odds: 2155.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 1, odds: 83.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 2, odds: 217.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 3, odds: 190.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 5, odds: 196.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 6, odds: 329.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 7, odds: 479.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 8, odds: 157.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 9, odds: 189.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 10, odds: 578.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 11, odds: 4444.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 12, odds: 52.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 13, odds: 1557.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 14, odds: 44.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 15, odds: 180.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 4, horse_number_2: 16, odds: 1185.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 1, odds: 229.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 2, odds: 426.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 3, odds: 437.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 4, odds: 244.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 6, odds: 470.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 7, odds: 1285.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 8, odds: 396.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 9, odds: 300.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 10, odds: 1403.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 11, odds: 4183.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 12, odds: 138.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 13, odds: 2922.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 14, odds: 85.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 15, odds: 295.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 5, horse_number_2: 16, odds: 2155.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 1, odds: 351.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 2, odds: 611.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 3, odds: 677.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 4, odds: 364.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 5, odds: 545.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 7, odds: 1748.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 8, odds: 476.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 9, odds: 575.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 10, odds: 2177.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 11, odds: 8534.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 12, odds: 196.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 13, odds: 4961.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 14, odds: 127.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 15, odds: 436.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 6, horse_number_2: 16, odds: 2883.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 1, odds: 522.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 2, odds: 1461.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 3, odds: 733.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 4, odds: 468.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 5, odds: 1641.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 6, odds: 1792.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 8, odds: 1431.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 9, odds: 1317.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 10, odds: 1333.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 11, odds: 7902.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 12, odds: 445.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 13, odds: 2539.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 14, odds: 401.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 15, odds: 867.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 7, horse_number_2: 16, odds: 9276.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 1, odds: 170.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 2, odds: 355.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 3, odds: 304.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 4, odds: 161.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 5, odds: 333.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 6, odds: 423.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 7, odds: 1262.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 9, odds: 252.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 10, odds: 1111.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 11, odds: 3809.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 12, odds: 92.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 13, odds: 2539.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 14, odds: 73.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 15, odds: 211.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 8, horse_number_2: 16, odds: 996.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 1, odds: 124.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 2, odds: 238.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 3, odds: 255.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 4, odds: 168.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 5, odds: 265.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 6, odds: 462.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 7, odds: 1212.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 8, odds: 285.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 10, odds: 1308.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 11, odds: 4025.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 12, odds: 76.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 13, odds: 2397.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 14, odds: 51.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 15, odds: 159.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 9, horse_number_2: 16, odds: 1580.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 1, odds: 701.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 2, odds: 3184.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 3, odds: 1128.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 4, odds: 826.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 5, odds: 1839.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 6, odds: 2570.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 7, odds: 1422.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 8, odds: 1922.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 9, odds: 2112.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 11, odds: 15239.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 12, odds: 735.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 13, odds: 21335.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 14, odds: 482.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 15, odds: 2133.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 10, horse_number_2: 16, odds: 6095.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 1, odds: 3386.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 2, odds: 3809.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 3, odds: 6275.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 4, odds: 7619.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 5, odds: 5333.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 6, odds: 7357.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 7, odds: 9276.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 8, odds: 5203.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 9, odds: 6095.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 10, odds: 17779.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 12, odds: 1628.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 13, odds: 16412.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 14, odds: 1808.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 15, odds: 4354.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 11, horse_number_2: 16, odds: 9276.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 1, odds: 34.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 2, odds: 69.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 3, odds: 74.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 4, odds: 35.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 5, odds: 79.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 6, odds: 121.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 7, odds: 361.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 8, odds: 71.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 9, odds: 58.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 10, odds: 339.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 11, odds: 1523.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 13, odds: 606.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 14, odds: 13.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 15, odds: 48.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 12, horse_number_2: 16, odds: 359.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 13, horse_number_2: 1, odds: 1513.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 13, horse_number_2: 2, odds: 4103.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 13, horse_number_2: 3, odds: 2177.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 13, horse_number_2: 4, odds: 1451.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 13, horse_number_2: 5, odds: 3879.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 13, horse_number_2: 6, odds: 4638.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 13, horse_number_2: 7, odds: 2807.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 13, horse_number_2: 8, odds: 3497.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 13, horse_number_2: 9, odds: 4025.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 13, horse_number_2: 10, odds: 16412.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 13, horse_number_2: 11, odds: 17779.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 13, horse_number_2: 12, odds: 1015.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 13, horse_number_2: 14, odds: 811.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 13, horse_number_2: 15, odds: 1056.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 13, horse_number_2: 16, odds: 13334.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 14, horse_number_2: 1, odds: 20.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 14, horse_number_2: 2, odds: 39.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 14, horse_number_2: 3, odds: 43.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 14, horse_number_2: 4, odds: 22.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 14, horse_number_2: 5, odds: 44.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 14, horse_number_2: 6, odds: 60.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 14, horse_number_2: 7, odds: 212.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 14, horse_number_2: 8, odds: 36.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 14, horse_number_2: 9, odds: 36.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 14, horse_number_2: 10, odds: 211.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 14, horse_number_2: 11, odds: 1247.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 14, horse_number_2: 12, odds: 10.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 14, horse_number_2: 13, odds: 364.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 14, horse_number_2: 15, odds: 28.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 14, horse_number_2: 16, odds: 214.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 15, horse_number_2: 1, odds: 84.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 15, horse_number_2: 2, odds: 246.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 15, horse_number_2: 3, odds: 188.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 15, horse_number_2: 4, odds: 161.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 15, horse_number_2: 5, odds: 262.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 15, horse_number_2: 6, odds: 339.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 15, horse_number_2: 7, odds: 604.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 15, horse_number_2: 8, odds: 224.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 15, horse_number_2: 9, odds: 158.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 15, horse_number_2: 10, odds: 1219.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 15, horse_number_2: 11, odds: 2883.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 15, horse_number_2: 12, odds: 61.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 15, horse_number_2: 13, odds: 1122.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 15, horse_number_2: 14, odds: 40.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 15, horse_number_2: 16, odds: 1140.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 1, odds: 927.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 2, odds: 2424.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 3, odds: 2344.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 4, odds: 1233.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 5, odds: 2319.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 6, odds: 3092.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 7, odds: 8534.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 8, odds: 1616.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 9, odds: 1975.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 10, odds: 4961.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 11, odds: 15239.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 12, odds: 576.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 13, odds: 15239.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 14, odds: 454.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 15, odds: 1557.3),
      ]
    end
  end
end
