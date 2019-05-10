require "timecop"
require "webmock/rspec"

require "spec_helper"

RSpec.describe InvestmentHorseRacing::Crawler::Parser::OddsTrifectaPageParser do
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

    ## 2018-06-24 hanshin 1R umaBan 1 odds trifecta page parser
    @url = "https://keiba.yahoo.co.jp/odds/st/1809030801/"
    WebMock.stub_request(:get, @url).to_return(
      status: [200, "OK"],
      body: File.open("spec/data/odds_trifecta.20180624.hanshin.1.1.html").read)

    @parser = InvestmentHorseRacing::Crawler::Parser::OddsTrifectaPageParser.new(@url, @downloader.download_with_get(@url))

    ## 2018-06-24 hanshin 1R umaBan 16 odds trifecta page parser
    @url_16 = "https://keiba.yahoo.co.jp/odds/st/1809030801/?umaBan=16"
    WebMock.stub_request(:get, @url_16).to_return(
      status: [200, "OK"],
      body: File.open("spec/data/odds_trifecta.20180624.hanshin.1.16.html").read)

    @parser_16 = InvestmentHorseRacing::Crawler::Parser::OddsTrifectaPageParser.new(@url_16, @downloader.download_with_get(@url_16))

    WebMock.disable!
  end

  describe "#redownload?" do
    context "2018-06-24 hanshin 1R umaBan 1 odds trifecta page" do
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

    context "2018-06-24 hanshin 1R umaBan 16 odds trifecta page" do
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

        expect(context).to be_empty

        expected = build_expected

        expect(InvestmentHorseRacing::Crawler::Model::OddsTrifecta.all).to match_array(expected)
      end

      it "overwrite when existing data" do
        meta_11111 = InvestmentHorseRacing::Crawler::Model::RaceMeta.create(race_id: "11111")
        meta_22222 = InvestmentHorseRacing::Crawler::Model::RaceMeta.create(race_id: "22222")

        InvestmentHorseRacing::Crawler::Model::OddsTrifecta.create(race_meta: meta_11111, horse_number_1:  1, horse_number_2: 1, horse_number_3: 1, odds: 111.11)
        InvestmentHorseRacing::Crawler::Model::OddsTrifecta.create(race_meta: meta_11111, horse_number_1:  2, horse_number_2: 1, horse_number_3: 1, odds: 111.11)
        InvestmentHorseRacing::Crawler::Model::OddsTrifecta.create(race_meta: meta_11111, horse_number_1: 16, horse_number_2: 1, horse_number_3: 1, odds: 111.11)
        InvestmentHorseRacing::Crawler::Model::OddsTrifecta.create(race_meta: meta_22222, horse_number_1:  1, horse_number_2: 2, horse_number_3: 2, odds: 222.22)
        InvestmentHorseRacing::Crawler::Model::OddsTrifecta.create(race_meta: meta_22222, horse_number_1:  2, horse_number_2: 2, horse_number_3: 2, odds: 222.22)
        InvestmentHorseRacing::Crawler::Model::OddsTrifecta.create(race_meta: meta_22222, horse_number_1: 16, horse_number_2: 2, horse_number_3: 2, odds: 222.22)
        InvestmentHorseRacing::Crawler::Model::OddsTrifecta.create(race_meta: @meta,      horse_number_1:  1, horse_number_2: 3, horse_number_3: 3, odds: 333.33)
        InvestmentHorseRacing::Crawler::Model::OddsTrifecta.create(race_meta: @meta,      horse_number_1:  2, horse_number_2: 3, horse_number_3: 3, odds: 333.33)
        InvestmentHorseRacing::Crawler::Model::OddsTrifecta.create(race_meta: @meta,      horse_number_1: 16, horse_number_2: 3, horse_number_3: 3, odds: 333.33)

        context = {}

        @parser.parse(context)

        expect(context).to be_empty

        expected = build_expected
        expected << have_attributes(race_meta_id: meta_11111.id, horse_number_1:  1, horse_number_2: 1, horse_number_3: 1, odds: 111.11)
        expected << have_attributes(race_meta_id: meta_11111.id, horse_number_1:  2, horse_number_2: 1, horse_number_3: 1, odds: 111.11)
        expected << have_attributes(race_meta_id: meta_11111.id, horse_number_1: 16, horse_number_2: 1, horse_number_3: 1, odds: 111.11)
        expected << have_attributes(race_meta_id: meta_22222.id, horse_number_1:  1, horse_number_2: 2, horse_number_3: 2, odds: 222.22)
        expected << have_attributes(race_meta_id: meta_22222.id, horse_number_1:  2, horse_number_2: 2, horse_number_3: 2, odds: 222.22)
        expected << have_attributes(race_meta_id: meta_22222.id, horse_number_1: 16, horse_number_2: 2, horse_number_3: 2, odds: 222.22)
        expected << have_attributes(race_meta_id: @meta.id,      horse_number_1:  2, horse_number_2: 3, horse_number_3: 3, odds: 333.33)
        expected << have_attributes(race_meta_id: @meta.id,      horse_number_1: 16, horse_number_2: 3, horse_number_3: 3, odds: 333.33)

        expect(InvestmentHorseRacing::Crawler::Model::OddsTrifecta.all).to match_array(expected)
      end
    end

    context "2018-06-24 hanshin 1R umaBan 16 odds trifecta page" do
      it "is odds trifecta info" do
        context = {}

        @parser_16.parse(context)

        expect(context).to be_empty

        expected_16 = build_expected_16

        expect(InvestmentHorseRacing::Crawler::Model::OddsTrifecta.all).to match_array(expected_16)
      end

      it "overwrite when existing data" do
        meta_11111 = InvestmentHorseRacing::Crawler::Model::RaceMeta.create(race_id: "11111")
        meta_22222 = InvestmentHorseRacing::Crawler::Model::RaceMeta.create(race_id: "22222")

        InvestmentHorseRacing::Crawler::Model::OddsTrifecta.create(race_meta: meta_11111, horse_number_1:  1, horse_number_2: 1, horse_number_3: 1, odds: 111.11)
        InvestmentHorseRacing::Crawler::Model::OddsTrifecta.create(race_meta: meta_11111, horse_number_1:  2, horse_number_2: 1, horse_number_3: 1, odds: 111.11)
        InvestmentHorseRacing::Crawler::Model::OddsTrifecta.create(race_meta: meta_11111, horse_number_1: 16, horse_number_2: 1, horse_number_3: 1, odds: 111.11)
        InvestmentHorseRacing::Crawler::Model::OddsTrifecta.create(race_meta: meta_22222, horse_number_1:  1, horse_number_2: 2, horse_number_3: 2, odds: 222.22)
        InvestmentHorseRacing::Crawler::Model::OddsTrifecta.create(race_meta: meta_22222, horse_number_1:  2, horse_number_2: 2, horse_number_3: 2, odds: 222.22)
        InvestmentHorseRacing::Crawler::Model::OddsTrifecta.create(race_meta: meta_22222, horse_number_1: 16, horse_number_2: 2, horse_number_3: 2, odds: 222.22)
        InvestmentHorseRacing::Crawler::Model::OddsTrifecta.create(race_meta: @meta,      horse_number_1:  1, horse_number_2: 3, horse_number_3: 3, odds: 333.33)
        InvestmentHorseRacing::Crawler::Model::OddsTrifecta.create(race_meta: @meta,      horse_number_1:  2, horse_number_2: 3, horse_number_3: 3, odds: 333.33)
        InvestmentHorseRacing::Crawler::Model::OddsTrifecta.create(race_meta: @meta,      horse_number_1: 16, horse_number_2: 3, horse_number_3: 3, odds: 333.33)

        context = {}

        @parser_16.parse(context)

        expect(context).to be_empty

        expected_16 = build_expected_16
        expected_16 << have_attributes(race_meta_id: meta_11111.id, horse_number_1:  1, horse_number_2: 1, horse_number_3: 1, odds: 111.11)
        expected_16 << have_attributes(race_meta_id: meta_11111.id, horse_number_1:  2, horse_number_2: 1, horse_number_3: 1, odds: 111.11)
        expected_16 << have_attributes(race_meta_id: meta_11111.id, horse_number_1: 16, horse_number_2: 1, horse_number_3: 1, odds: 111.11)
        expected_16 << have_attributes(race_meta_id: meta_22222.id, horse_number_1:  1, horse_number_2: 2, horse_number_3: 2, odds: 222.22)
        expected_16 << have_attributes(race_meta_id: meta_22222.id, horse_number_1:  2, horse_number_2: 2, horse_number_3: 2, odds: 222.22)
        expected_16 << have_attributes(race_meta_id: meta_22222.id, horse_number_1: 16, horse_number_2: 2, horse_number_3: 2, odds: 222.22)
        expected_16 << have_attributes(race_meta_id: @meta.id,      horse_number_1:  1, horse_number_2: 3, horse_number_3: 3, odds: 333.33)
        expected_16 << have_attributes(race_meta_id: @meta.id,      horse_number_1:  2, horse_number_2: 3, horse_number_3: 3, odds: 333.33)

        expect(InvestmentHorseRacing::Crawler::Model::OddsTrifecta.all).to match_array(expected_16)
      end
    end

    context "valid page on web" do
      it "parse success" do
        parser = InvestmentHorseRacing::Crawler::Parser::OddsTrifectaPageParser.new(@url, @downloader.download_with_get(@url))

        context = {}

        parser.parse(context)

        expect(context).to be_empty

        expect(InvestmentHorseRacing::Crawler::Model::OddsTrifecta.count).to be > 0
      end
    end

    def build_expected
      [
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 2, horse_number_3: 3, odds: 558.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 2, horse_number_3: 4, odds: 935.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 2, horse_number_3: 5, odds: 1680.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 2, horse_number_3: 6, odds: 2423.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 2, horse_number_3: 7, odds: 5019.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 2, horse_number_3: 8, odds: 1542.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 2, horse_number_3: 9, odds: 1081.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 2, horse_number_3: 10, odds: 9313.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 2, horse_number_3: 11, odds: 16804.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 2, horse_number_3: 12, odds: 574.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 2, horse_number_3: 13, odds: 13102.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 2, horse_number_3: 14, odds: 384.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 2, horse_number_3: 15, odds: 1288.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 2, horse_number_3: 16, odds: 7027.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 3, horse_number_3: 2, odds: 661.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 3, horse_number_3: 4, odds: 805.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 3, horse_number_3: 5, odds: 1277.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 3, horse_number_3: 6, odds: 1752.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 3, horse_number_3: 7, odds: 2061.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 3, horse_number_3: 8, odds: 1279.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 3, horse_number_3: 9, odds: 1090.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 3, horse_number_3: 10, odds: 2712.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 3, horse_number_3: 11, odds: 29731.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 3, horse_number_3: 12, odds: 644.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 3, horse_number_3: 13, odds: 10171.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 3, horse_number_3: 14, odds: 407.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 3, horse_number_3: 15, odds: 942.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 3, horse_number_3: 16, odds: 11203.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 4, horse_number_3: 2, odds: 1093.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 4, horse_number_3: 3, odds: 876.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 4, horse_number_3: 5, odds: 1099.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 4, horse_number_3: 6, odds: 1503.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 4, horse_number_3: 7, odds: 2253.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 4, horse_number_3: 8, odds: 949.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 4, horse_number_3: 9, odds: 1358.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 4, horse_number_3: 10, odds: 2702.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 4, horse_number_3: 11, odds: 22086.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 4, horse_number_3: 12, odds: 516.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 4, horse_number_3: 13, odds: 12672.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 4, horse_number_3: 14, odds: 310.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 4, horse_number_3: 15, odds: 1101.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 4, horse_number_3: 16, odds: 8137.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 5, horse_number_3: 2, odds: 2253.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 5, horse_number_3: 3, odds: 1464.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 5, horse_number_3: 4, odds: 1138.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 5, horse_number_3: 6, odds: 2177.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 5, horse_number_3: 7, odds: 3807.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 5, horse_number_3: 8, odds: 1810.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 5, horse_number_3: 9, odds: 2247.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 5, horse_number_3: 10, odds: 3884.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 5, horse_number_3: 11, odds: 48313.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 5, horse_number_3: 12, odds: 1050.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 5, horse_number_3: 13, odds: 26655.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 5, horse_number_3: 14, odds: 763.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 5, horse_number_3: 15, odds: 1717.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 5, horse_number_3: 16, odds: 11367.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 6, horse_number_3: 2, odds: 3031.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 6, horse_number_3: 3, odds: 1871.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 6, horse_number_3: 4, odds: 1801.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 6, horse_number_3: 5, odds: 2423.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 6, horse_number_3: 7, odds: 4417.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 6, horse_number_3: 8, odds: 2045.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 6, horse_number_3: 9, odds: 4111.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 6, horse_number_3: 10, odds: 3865.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 6, horse_number_3: 11, odds: 48313.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 6, horse_number_3: 12, odds: 1571.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 6, horse_number_3: 13, odds: 28630.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 6, horse_number_3: 14, odds: 1082.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 6, horse_number_3: 15, odds: 2446.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 6, horse_number_3: 16, odds: 18405.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 7, horse_number_3: 2, odds: 6901.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 7, horse_number_3: 3, odds: 2247.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 7, horse_number_3: 4, odds: 2770.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 7, horse_number_3: 5, odds: 4417.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 7, horse_number_3: 6, odds: 4801.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 7, horse_number_3: 8, odds: 3789.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 7, horse_number_3: 9, odds: 7432.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 7, horse_number_3: 10, odds: 5561.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 7, horse_number_3: 11, odds: 55215.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 7, horse_number_3: 12, odds: 2602.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 7, horse_number_3: 13, odds: 59463.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 7, horse_number_3: 14, odds: 2018.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 7, horse_number_3: 15, odds: 3207.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 7, horse_number_3: 16, odds: 27607.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 8, horse_number_3: 2, odds: 1890.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 8, horse_number_3: 3, odds: 1597.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 8, horse_number_3: 4, odds: 1138.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 8, horse_number_3: 5, odds: 2260.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 8, horse_number_3: 6, odds: 2712.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 8, horse_number_3: 7, odds: 6284.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 8, horse_number_3: 9, odds: 2013.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 8, horse_number_3: 10, odds: 5521.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 8, horse_number_3: 11, odds: 32209.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 8, horse_number_3: 12, odds: 967.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 8, horse_number_3: 13, odds: 17977.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 8, horse_number_3: 14, odds: 612.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 8, horse_number_3: 15, odds: 1623.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 8, horse_number_3: 16, odds: 8589.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 9, horse_number_3: 2, odds: 1191.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 9, horse_number_3: 3, odds: 1050.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 9, horse_number_3: 4, odds: 1277.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 9, horse_number_3: 5, odds: 1867.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 9, horse_number_3: 6, odds: 3405.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 9, horse_number_3: 7, odds: 5642.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 9, horse_number_3: 8, odds: 1823.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 9, horse_number_3: 10, odds: 8988.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 9, horse_number_3: 11, odds: 27607.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 9, horse_number_3: 12, odds: 709.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 9, horse_number_3: 13, odds: 18405.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 9, horse_number_3: 14, odds: 399.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 9, horse_number_3: 15, odds: 1271.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 9, horse_number_3: 16, odds: 10589.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 10, horse_number_3: 2, odds: 11892.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 10, horse_number_3: 3, odds: 2841.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 10, horse_number_3: 4, odds: 3117.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 10, horse_number_3: 5, odds: 4628.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 10, horse_number_3: 6, odds: 4742.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 10, horse_number_3: 7, odds: 5900.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 10, horse_number_3: 8, odds: 4367.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 10, horse_number_3: 9, odds: 12883.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 10, horse_number_3: 11, odds: 64418.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 10, horse_number_3: 12, odds: 3529.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 10, horse_number_3: 13, odds: 77302.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 10, horse_number_3: 14, odds: 2559.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 10, horse_number_3: 15, odds: 4742.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 10, horse_number_3: 16, odds: 23424.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 11, horse_number_3: 2, odds: 30920.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 11, horse_number_3: 3, odds: 42945.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 11, horse_number_3: 4, odds: 35137.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 11, horse_number_3: 5, odds: 85891.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 11, horse_number_3: 6, odds: 77302.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 11, horse_number_3: 7, odds: 59463.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 11, horse_number_3: 8, odds: 36810.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 11, horse_number_3: 9, odds: 64418.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 11, horse_number_3: 10, odds: 96627.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 11, horse_number_3: 12, odds: 25767.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 11, horse_number_3: 13, odds: 110431.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 11, horse_number_3: 14, odds: 16104.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 11, horse_number_3: 15, odds: 33609.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 11, horse_number_3: 16, odds: 110431.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 12, horse_number_3: 2, odds: 436.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 12, horse_number_3: 3, odds: 502.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 12, horse_number_3: 4, odds: 401.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 12, horse_number_3: 5, odds: 706.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 12, horse_number_3: 6, odds: 1105.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 12, horse_number_3: 7, odds: 2045.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 12, horse_number_3: 8, odds: 645.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 12, horse_number_3: 9, odds: 508.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 12, horse_number_3: 10, odds: 2430.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 12, horse_number_3: 11, odds: 13561.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 12, horse_number_3: 13, odds: 5223.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 12, horse_number_3: 14, odds: 112.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 12, horse_number_3: 15, odds: 387.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 12, horse_number_3: 16, odds: 3826.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 13, horse_number_3: 2, odds: 26655.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 13, horse_number_3: 3, odds: 15157.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 13, horse_number_3: 4, odds: 17178.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 13, horse_number_3: 5, odds: 35137.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 13, horse_number_3: 6, odds: 40685.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 13, horse_number_3: 7, odds: 42945.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 13, horse_number_3: 8, odds: 28630.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 13, horse_number_3: 9, odds: 36810.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 13, horse_number_3: 10, odds: 77302.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 13, horse_number_3: 11, odds: 110431.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 13, horse_number_3: 12, odds: 10887.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 13, horse_number_3: 14, odds: 8402.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 13, horse_number_3: 15, odds: 20342.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 13, horse_number_3: 16, odds: 42945.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 14, horse_number_3: 2, odds: 275.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 14, horse_number_3: 3, odds: 294.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 14, horse_number_3: 4, odds: 251.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 14, horse_number_3: 5, odds: 470.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 14, horse_number_3: 6, odds: 687.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 14, horse_number_3: 7, odds: 1349.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 14, horse_number_3: 8, odds: 383.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 14, horse_number_3: 9, odds: 277.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 14, horse_number_3: 10, odds: 1561.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 14, horse_number_3: 11, odds: 6901.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 14, horse_number_3: 12, odds: 109.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 14, horse_number_3: 13, odds: 3789.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 14, horse_number_3: 15, odds: 224.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 14, horse_number_3: 16, odds: 2454.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 15, horse_number_3: 2, odds: 1164.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 15, horse_number_3: 3, odds: 792.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 15, horse_number_3: 4, odds: 920.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 15, horse_number_3: 5, odds: 1546.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 15, horse_number_3: 6, odds: 1977.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 15, horse_number_3: 7, odds: 2620.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 15, horse_number_3: 8, odds: 1164.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 15, horse_number_3: 9, odds: 1000.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 15, horse_number_3: 10, odds: 3770.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 15, horse_number_3: 11, odds: 19821.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 15, horse_number_3: 12, odds: 484.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 15, horse_number_3: 13, odds: 13803.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 15, horse_number_3: 14, odds: 303.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 15, horse_number_3: 16, odds: 7157.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 16, horse_number_3: 2, odds: 10589.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 16, horse_number_3: 3, odds: 16447.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 16, horse_number_3: 4, odds: 10887.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 16, horse_number_3: 5, odds: 20892.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 16, horse_number_3: 6, odds: 35137.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 16, horse_number_3: 7, odds: 35137.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 16, horse_number_3: 8, odds: 13102.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 16, horse_number_3: 9, odds: 17178.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 16, horse_number_3: 10, odds: 24936.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 16, horse_number_3: 11, odds: 77302.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 16, horse_number_3: 12, odds: 6964.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 16, horse_number_3: 13, odds: 70274.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 16, horse_number_3: 14, odds: 4178.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 1, horse_number_2: 16, horse_number_3: 15, odds: 11892.6),
      ]
    end

    def build_expected_16
      [
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 1, horse_number_3: 2, odds: 14054.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 1, horse_number_3: 3, odds: 20342.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 1, horse_number_3: 4, odds: 13102.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 1, horse_number_3: 5, odds: 35137.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 1, horse_number_3: 6, odds: 51534.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 1, horse_number_3: 7, odds: 45471.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 1, horse_number_3: 8, odds: 18405.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 1, horse_number_3: 9, odds: 21472.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 1, horse_number_3: 10, odds: 30920.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 1, horse_number_3: 11, odds: 128837.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 1, horse_number_3: 12, odds: 9202.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 1, horse_number_3: 13, odds: 96627.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 1, horse_number_3: 14, odds: 5368.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 1, horse_number_3: 15, odds: 14865.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 2, horse_number_3: 1, odds: 15775.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 2, horse_number_3: 3, odds: 28630.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 2, horse_number_3: 4, odds: 36810.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 2, horse_number_3: 5, odds: 77302.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 2, horse_number_3: 6, odds: 128837.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 2, horse_number_3: 7, odds: 96627.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 2, horse_number_3: 8, odds: 59463.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 2, horse_number_3: 9, odds: 36810.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 2, horse_number_3: 10, odds: 257674.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 2, horse_number_3: 11, odds: 96627.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 2, horse_number_3: 12, odds: 18854.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 2, horse_number_3: 13, odds: 257674.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 2, horse_number_3: 14, odds: 13327.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 2, horse_number_3: 15, odds: 45471.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 3, horse_number_3: 1, odds: 20342.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 3, horse_number_3: 2, odds: 29731.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 3, horse_number_3: 4, odds: 17977.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 3, horse_number_3: 5, odds: 48313.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 3, horse_number_3: 6, odds: 110431.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 3, horse_number_3: 7, odds: 59463.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 3, horse_number_3: 8, odds: 51534.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 3, horse_number_3: 9, odds: 24156.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 3, horse_number_3: 10, odds: 33609.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 3, horse_number_3: 11, odds: 96627.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 3, horse_number_3: 12, odds: 19821.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 3, horse_number_3: 13, odds: 128837.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 3, horse_number_3: 14, odds: 11203.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 3, horse_number_3: 15, odds: 38651.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 4, horse_number_3: 1, odds: 16447.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 4, horse_number_3: 2, odds: 35137.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 4, horse_number_3: 3, odds: 19325.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 4, horse_number_3: 5, odds: 19325.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 4, horse_number_3: 6, odds: 30920.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 4, horse_number_3: 7, odds: 64418.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 4, horse_number_3: 8, odds: 19821.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 4, horse_number_3: 9, odds: 30920.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 4, horse_number_3: 10, odds: 96627.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 4, horse_number_3: 11, odds: 257674.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 4, horse_number_3: 12, odds: 7505.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 4, horse_number_3: 13, odds: 96627.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 4, horse_number_3: 14, odds: 5856.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 4, horse_number_3: 15, odds: 20892.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 5, horse_number_3: 1, odds: 40685.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 5, horse_number_3: 2, odds: 70274.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 5, horse_number_3: 3, odds: 51534.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 5, horse_number_3: 4, odds: 27607.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 5, horse_number_3: 6, odds: 85891.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 5, horse_number_3: 7, odds: 257674.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 5, horse_number_3: 8, odds: 70274.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 5, horse_number_3: 9, odds: 64418.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 5, horse_number_3: 10, odds: 110431.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 5, horse_number_3: 11, odds: 257674.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 5, horse_number_3: 12, odds: 21472.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 5, horse_number_3: 13, odds: 386511.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 5, horse_number_3: 14, odds: 14054.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 5, horse_number_3: 15, odds: 59463.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 6, horse_number_3: 1, odds: 59463.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 6, horse_number_3: 2, odds: 128837.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 6, horse_number_3: 3, odds: 110431.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 6, horse_number_3: 4, odds: 38651.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 6, horse_number_3: 5, odds: 77302.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 6, horse_number_3: 7, odds: 154604.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 6, horse_number_3: 8, odds: 77302.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 6, horse_number_3: 9, odds: 70274.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 6, horse_number_3: 10, odds: 40685.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 6, horse_number_3: 11, odds: 257674.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 6, horse_number_3: 12, odds: 32209.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 6, horse_number_3: 13, odds: 386511.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 6, horse_number_3: 14, odds: 19325.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 6, horse_number_3: 15, odds: 193255.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 7, horse_number_3: 1, odds: 45471.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 7, horse_number_3: 2, odds: 77302.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 7, horse_number_3: 3, odds: 59463.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 7, horse_number_3: 4, odds: 77302.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 7, horse_number_3: 5, odds: 128837.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 7, horse_number_3: 6, odds: 154604.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 7, horse_number_3: 8, odds: 96627.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 7, horse_number_3: 9, odds: 59463.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 7, horse_number_3: 10, odds: 96627.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 7, horse_number_3: 11, odds: 193255.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 7, horse_number_3: 12, odds: 128837.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 7, horse_number_3: 13, odds: 193255.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 7, horse_number_3: 14, odds: 35137.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 7, horse_number_3: 15, odds: 85891.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 8, horse_number_3: 1, odds: 17977.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 8, horse_number_3: 2, odds: 51534.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 8, horse_number_3: 3, odds: 48313.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 8, horse_number_3: 4, odds: 19325.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 8, horse_number_3: 5, odds: 64418.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 8, horse_number_3: 6, odds: 77302.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 8, horse_number_3: 7, odds: 77302.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 8, horse_number_3: 9, odds: 42945.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 8, horse_number_3: 10, odds: 42945.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 8, horse_number_3: 11, odds: 257674.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 8, horse_number_3: 12, odds: 12883.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 8, horse_number_3: 13, odds: 154604.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 8, horse_number_3: 14, odds: 10736.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 8, horse_number_3: 15, odds: 42945.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 9, horse_number_3: 1, odds: 24936.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 9, horse_number_3: 2, odds: 33609.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 9, horse_number_3: 3, odds: 22735.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 9, horse_number_3: 4, odds: 28630.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 9, horse_number_3: 5, odds: 59463.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 9, horse_number_3: 6, odds: 64418.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 9, horse_number_3: 7, odds: 70274.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 9, horse_number_3: 8, odds: 35137.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 9, horse_number_3: 10, odds: 55215.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 9, horse_number_3: 11, odds: 64418.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 9, horse_number_3: 12, odds: 14315.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 9, horse_number_3: 13, odds: 96627.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 9, horse_number_3: 14, odds: 9094.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 9, horse_number_3: 15, odds: 35137.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 10, horse_number_3: 1, odds: 33609.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 10, horse_number_3: 2, odds: 193255.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 10, horse_number_3: 3, odds: 38651.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 10, horse_number_3: 4, odds: 42945.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 10, horse_number_3: 5, odds: 128837.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 10, horse_number_3: 6, odds: 38651.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 10, horse_number_3: 7, odds: 70274.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 10, horse_number_3: 8, odds: 42945.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 10, horse_number_3: 9, odds: 51534.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 10, horse_number_3: 11, odds: 386511.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 10, horse_number_3: 12, odds: 24936.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 10, horse_number_3: 13, odds: 257674.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 10, horse_number_3: 14, odds: 21472.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 10, horse_number_3: 15, odds: 128837.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 11, horse_number_3: 1, odds: 193255.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 11, horse_number_3: 2, odds: 110431.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 11, horse_number_3: 3, odds: 193255.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 11, horse_number_3: 4, odds: 386511.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 11, horse_number_3: 5, odds: 257674.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 11, horse_number_3: 6, odds: 386511.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 11, horse_number_3: 7, odds: 257674.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 11, horse_number_3: 8, odds: 386511.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 11, horse_number_3: 9, odds: 773022.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 11, horse_number_3: 10, odds: 257674.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 11, horse_number_3: 12, odds: 386511.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 11, horse_number_3: 13, odds: 110431.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 11, horse_number_3: 14, odds: 128837.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 11, horse_number_3: 15, odds: 386511.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 12, horse_number_3: 1, odds: 7969.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 12, horse_number_3: 2, odds: 15157.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 12, horse_number_3: 3, odds: 12078.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 12, horse_number_3: 4, odds: 5368.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 12, horse_number_3: 5, odds: 14315.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 12, horse_number_3: 6, odds: 20892.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 12, horse_number_3: 7, odds: 64418.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 12, horse_number_3: 8, odds: 10039.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 12, horse_number_3: 9, odds: 14315.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 12, horse_number_3: 10, odds: 20892.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 12, horse_number_3: 11, odds: 193255.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 12, horse_number_3: 13, odds: 96627.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 12, horse_number_3: 14, odds: 2039.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 12, horse_number_3: 15, odds: 10446.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 13, horse_number_3: 1, odds: 110431.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 13, horse_number_3: 2, odds: 193255.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 13, horse_number_3: 3, odds: 96627.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 13, horse_number_3: 4, odds: 128837.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 13, horse_number_3: 5, odds: 386511.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 13, horse_number_3: 6, odds: 773022.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 13, horse_number_3: 7, odds: 257674.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 13, horse_number_3: 8, odds: 193255.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 13, horse_number_3: 9, odds: 154604.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 13, horse_number_3: 10, odds: 128837.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 13, horse_number_3: 11, odds: 110431.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 13, horse_number_3: 12, odds: 128837.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 13, horse_number_3: 14, odds: 33609.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 13, horse_number_3: 15, odds: 154604.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 14, horse_number_3: 1, odds: 5258.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 14, horse_number_3: 2, odds: 9427.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 14, horse_number_3: 3, odds: 9785.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 14, horse_number_3: 4, odds: 4601.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 14, horse_number_3: 5, odds: 8784.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 14, horse_number_3: 6, odds: 16447.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 14, horse_number_3: 7, odds: 26655.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 14, horse_number_3: 8, odds: 8312.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 14, horse_number_3: 9, odds: 8784.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 14, horse_number_3: 10, odds: 18854.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 14, horse_number_3: 11, odds: 96627.8),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 14, horse_number_3: 12, odds: 1982.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 14, horse_number_3: 13, odds: 20342.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 14, horse_number_3: 15, odds: 5405.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 15, horse_number_3: 1, odds: 14054.9),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 15, horse_number_3: 2, odds: 38651.1),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 15, horse_number_3: 3, odds: 32209.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 15, horse_number_3: 4, odds: 20892.5),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 15, horse_number_3: 5, odds: 40685.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 15, horse_number_3: 6, odds: 128837.0),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 15, horse_number_3: 7, odds: 77302.2),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 15, horse_number_3: 8, odds: 35137.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 15, horse_number_3: 9, odds: 28630.4),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 15, horse_number_3: 10, odds: 110431.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 15, horse_number_3: 11, odds: 193255.6),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 15, horse_number_3: 12, odds: 14585.3),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 15, horse_number_3: 13, odds: 110431.7),
        have_attributes(race_meta_id: @meta.id, horse_number_1: 16, horse_number_2: 15, horse_number_3: 14, odds: 6551.0),
      ]
    end
  end
end
