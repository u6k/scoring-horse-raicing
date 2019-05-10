require "timecop"
require "webmock/rspec"

require "spec_helper"

RSpec.describe InvestmentHorseRacing::Crawler::Parser::OddsWinPageParser do
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

    ## 2018-06-24 hanshin 1R odds win page parser
    @url = "https://keiba.yahoo.co.jp/odds/tfw/1809030801/"
    WebMock.stub_request(:get, @url).to_return(
      status: [200, "OK"],
      body: File.open("spec/data/odds_win.20180624.hanshin.1.html").read)

    @parser = InvestmentHorseRacing::Crawler::Parser::OddsWinPageParser.new(@url, @downloader.download_with_get(@url))

    WebMock.disable!
  end

  describe "#redownload?" do
    context "2018-06-24 hanshin 1R odds win page" do
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
    context "2018-06-24 hanshin 1R odds win page" do
      it "is odds pages" do
        expect(@parser.related_links).to contain_exactly(
          "https://keiba.yahoo.co.jp/odds/ur/1809030801/",
          "https://keiba.yahoo.co.jp/odds/wide/1809030801/",
          "https://keiba.yahoo.co.jp/odds/ut/1809030801/",
          "https://keiba.yahoo.co.jp/odds/sf/1809030801/",
          "https://keiba.yahoo.co.jp/odds/st/1809030801/")
      end
    end
  end

  describe "#parse" do
    context "2018-06-24 hanshin 1R odds win page" do
      it "is odds win info" do
        context = {}

        @parser.parse(context)

        expect(context).to be_empty

        expect(InvestmentHorseRacing::Crawler::Model::OddsWin.all).to match_array([
          have_attributes(race_meta_id: @meta.id, horse_number: 1, odds: 6.9),
          have_attributes(race_meta_id: @meta.id, horse_number: 2, odds: 19.9),
          have_attributes(race_meta_id: @meta.id, horse_number: 3, odds: 15.0),
          have_attributes(race_meta_id: @meta.id, horse_number: 4, odds: 11.8),
          have_attributes(race_meta_id: @meta.id, horse_number: 5, odds: 24.8),
          have_attributes(race_meta_id: @meta.id, horse_number: 6, odds: 34.1),
          have_attributes(race_meta_id: @meta.id, horse_number: 7, odds: 65.9),
          have_attributes(race_meta_id: @meta.id, horse_number: 8, odds: 17.6),
          have_attributes(race_meta_id: @meta.id, horse_number: 9, odds: 15.4),
          have_attributes(race_meta_id: @meta.id, horse_number: 10, odds: 97.6),
          have_attributes(race_meta_id: @meta.id, horse_number: 11, odds: 281.6),
          have_attributes(race_meta_id: @meta.id, horse_number: 12, odds: 4.1),
          have_attributes(race_meta_id: @meta.id, horse_number: 13, odds: 158.4),
          have_attributes(race_meta_id: @meta.id, horse_number: 14, odds: 2.9),
          have_attributes(race_meta_id: @meta.id, horse_number: 15, odds: 11.8),
          have_attributes(race_meta_id: @meta.id, horse_number: 16, odds: 96.9),
        ])

        expect(InvestmentHorseRacing::Crawler::Model::OddsPlace.all).to match_array([
          have_attributes(race_meta_id: @meta.id, horse_number: 1, odds_1: 1.7, odds_2: 2.6),
          have_attributes(race_meta_id: @meta.id, horse_number: 2, odds_1: 4.3, odds_2: 7.1),
          have_attributes(race_meta_id: @meta.id, horse_number: 3, odds_1: 3.7, odds_2: 6.0),
          have_attributes(race_meta_id: @meta.id, horse_number: 4, odds_1: 2.1, odds_2: 3.3),
          have_attributes(race_meta_id: @meta.id, horse_number: 5, odds_1: 4.4, odds_2: 7.2),
          have_attributes(race_meta_id: @meta.id, horse_number: 6, odds_1: 5.6, odds_2: 9.2),
          have_attributes(race_meta_id: @meta.id, horse_number: 7, odds_1: 14.9, odds_2: 25.3),
          have_attributes(race_meta_id: @meta.id, horse_number: 8, odds_1: 3.9, odds_2: 6.4),
          have_attributes(race_meta_id: @meta.id, horse_number: 9, odds_1: 3.4, odds_2: 5.5),
          have_attributes(race_meta_id: @meta.id, horse_number: 10, odds_1: 15.2, odds_2: 25.8),
          have_attributes(race_meta_id: @meta.id, horse_number: 11, odds_1: 49.9, odds_2: 85.2),
          have_attributes(race_meta_id: @meta.id, horse_number: 12, odds_1: 1.5, odds_2: 2.1),
          have_attributes(race_meta_id: @meta.id, horse_number: 13, odds_1: 31.9, odds_2: 54.5),
          have_attributes(race_meta_id: @meta.id, horse_number: 14, odds_1: 1.2, odds_2: 1.5),
          have_attributes(race_meta_id: @meta.id, horse_number: 15, odds_1: 2.9, odds_2: 4.7),
          have_attributes(race_meta_id: @meta.id, horse_number: 16, odds_1: 17.4, odds_2: 29.7),
        ])

        expect(InvestmentHorseRacing::Crawler::Model::OddsBracketQuinella.all).to match_array([
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 1, bracket_number_2: 1, odds: 48.9),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 1, bracket_number_2: 2, odds: 13.8),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 1, bracket_number_2: 3, odds: 26.4),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 1, bracket_number_2: 4, odds: 38.5),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 1, bracket_number_2: 5, odds: 33.2),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 1, bracket_number_2: 6, odds: 11.4),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 1, bracket_number_2: 7, odds: 7.0),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 1, bracket_number_2: 8, odds: 28.6),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 2, bracket_number_2: 2, odds: 102.6),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 2, bracket_number_2: 3, odds: 33.3),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 2, bracket_number_2: 4, odds: 48.4),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 2, bracket_number_2: 5, odds: 41.7),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 2, bracket_number_2: 6, odds: 16.2),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 2, bracket_number_2: 7, odds: 11.0),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 2, bracket_number_2: 8, odds: 46.8),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 3, bracket_number_2: 3, odds: 189.7),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 3, bracket_number_2: 4, odds: 68.2),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 3, bracket_number_2: 5, odds: 65.2),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 3, bracket_number_2: 6, odds: 27.8),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 3, bracket_number_2: 7, odds: 20.3),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 3, bracket_number_2: 8, odds: 66.5),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 4, bracket_number_2: 4, odds: 478.8),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 4, bracket_number_2: 5, odds: 94.7),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 4, bracket_number_2: 6, odds: 37.2),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 4, bracket_number_2: 7, odds: 22.9),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 4, bracket_number_2: 8, odds: 95.0),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 5, bracket_number_2: 5, odds: 445.9),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 5, bracket_number_2: 6, odds: 32.9),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 5, bracket_number_2: 7, odds: 22.4),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 5, bracket_number_2: 8, odds: 66.0),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 6, bracket_number_2: 6, odds: 255.7),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 6, bracket_number_2: 7, odds: 6.2),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 6, bracket_number_2: 8, odds: 28.2),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 7, bracket_number_2: 7, odds: 240.8),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 7, bracket_number_2: 8, odds: 18.3),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 8, bracket_number_2: 8, odds: 418.7),
        ])
      end

      it "overwrite when existing data" do
        meta_11111 = InvestmentHorseRacing::Crawler::Model::RaceMeta.create(race_id: "11111")
        meta_22222 = InvestmentHorseRacing::Crawler::Model::RaceMeta.create(race_id: "22222")

        InvestmentHorseRacing::Crawler::Model::OddsWin.create(race_meta: meta_11111, horse_number: 1, odds: 111.11)
        InvestmentHorseRacing::Crawler::Model::OddsWin.create(race_meta: meta_22222, horse_number: 2, odds: 222.22)
        InvestmentHorseRacing::Crawler::Model::OddsWin.create(race_meta: @meta,      horse_number: 3, odds: 333.33)

        InvestmentHorseRacing::Crawler::Model::OddsPlace.create(race_meta: meta_11111, horse_number: 1, odds_1: 111.11, odds_2: 111.22)
        InvestmentHorseRacing::Crawler::Model::OddsPlace.create(race_meta: meta_22222, horse_number: 2, odds_1: 222.11, odds_2: 222.22)
        InvestmentHorseRacing::Crawler::Model::OddsPlace.create(race_meta: @meta,      horse_number: 3, odds_1: 333.11, odds_2: 333.22)

        InvestmentHorseRacing::Crawler::Model::OddsBracketQuinella.create(race_meta: meta_11111, bracket_number_1: 1, bracket_number_2: 1, odds: 111.11)
        InvestmentHorseRacing::Crawler::Model::OddsBracketQuinella.create(race_meta: meta_22222, bracket_number_1: 2, bracket_number_2: 2, odds: 222.22)
        InvestmentHorseRacing::Crawler::Model::OddsBracketQuinella.create(race_meta: @meta     , bracket_number_1: 3, bracket_number_2: 3, odds: 333.33)

        context = {}

        @parser.parse(context)

        expect(context).to be_empty

        expect(InvestmentHorseRacing::Crawler::Model::OddsWin.all).to match_array([
          have_attributes(race_meta_id: meta_11111.id, horse_number: 1, odds: 111.11),
          have_attributes(race_meta_id: meta_22222.id, horse_number: 2, odds: 222.22),
          have_attributes(race_meta_id: @meta.id, horse_number: 1, odds: 6.9),
          have_attributes(race_meta_id: @meta.id, horse_number: 2, odds: 19.9),
          have_attributes(race_meta_id: @meta.id, horse_number: 3, odds: 15.0),
          have_attributes(race_meta_id: @meta.id, horse_number: 4, odds: 11.8),
          have_attributes(race_meta_id: @meta.id, horse_number: 5, odds: 24.8),
          have_attributes(race_meta_id: @meta.id, horse_number: 6, odds: 34.1),
          have_attributes(race_meta_id: @meta.id, horse_number: 7, odds: 65.9),
          have_attributes(race_meta_id: @meta.id, horse_number: 8, odds: 17.6),
          have_attributes(race_meta_id: @meta.id, horse_number: 9, odds: 15.4),
          have_attributes(race_meta_id: @meta.id, horse_number: 10, odds: 97.6),
          have_attributes(race_meta_id: @meta.id, horse_number: 11, odds: 281.6),
          have_attributes(race_meta_id: @meta.id, horse_number: 12, odds: 4.1),
          have_attributes(race_meta_id: @meta.id, horse_number: 13, odds: 158.4),
          have_attributes(race_meta_id: @meta.id, horse_number: 14, odds: 2.9),
          have_attributes(race_meta_id: @meta.id, horse_number: 15, odds: 11.8),
          have_attributes(race_meta_id: @meta.id, horse_number: 16, odds: 96.9),
        ])

        expect(InvestmentHorseRacing::Crawler::Model::OddsPlace.all).to match_array([
          have_attributes(race_meta_id: meta_11111.id, horse_number: 1, odds_1: 111.11, odds_2: 111.22),
          have_attributes(race_meta_id: meta_22222.id, horse_number: 2, odds_1: 222.11, odds_2: 222.22),
          have_attributes(race_meta_id: @meta.id, horse_number: 1, odds_1: 1.7, odds_2: 2.6),
          have_attributes(race_meta_id: @meta.id, horse_number: 2, odds_1: 4.3, odds_2: 7.1),
          have_attributes(race_meta_id: @meta.id, horse_number: 3, odds_1: 3.7, odds_2: 6.0),
          have_attributes(race_meta_id: @meta.id, horse_number: 4, odds_1: 2.1, odds_2: 3.3),
          have_attributes(race_meta_id: @meta.id, horse_number: 5, odds_1: 4.4, odds_2: 7.2),
          have_attributes(race_meta_id: @meta.id, horse_number: 6, odds_1: 5.6, odds_2: 9.2),
          have_attributes(race_meta_id: @meta.id, horse_number: 7, odds_1: 14.9, odds_2: 25.3),
          have_attributes(race_meta_id: @meta.id, horse_number: 8, odds_1: 3.9, odds_2: 6.4),
          have_attributes(race_meta_id: @meta.id, horse_number: 9, odds_1: 3.4, odds_2: 5.5),
          have_attributes(race_meta_id: @meta.id, horse_number: 10, odds_1: 15.2, odds_2: 25.8),
          have_attributes(race_meta_id: @meta.id, horse_number: 11, odds_1: 49.9, odds_2: 85.2),
          have_attributes(race_meta_id: @meta.id, horse_number: 12, odds_1: 1.5, odds_2: 2.1),
          have_attributes(race_meta_id: @meta.id, horse_number: 13, odds_1: 31.9, odds_2: 54.5),
          have_attributes(race_meta_id: @meta.id, horse_number: 14, odds_1: 1.2, odds_2: 1.5),
          have_attributes(race_meta_id: @meta.id, horse_number: 15, odds_1: 2.9, odds_2: 4.7),
          have_attributes(race_meta_id: @meta.id, horse_number: 16, odds_1: 17.4, odds_2: 29.7),
        ])

        expect(InvestmentHorseRacing::Crawler::Model::OddsBracketQuinella.all).to match_array([
          have_attributes(race_meta_id: meta_11111.id, bracket_number_1: 1, bracket_number_2: 1, odds: 111.11),
          have_attributes(race_meta_id: meta_22222.id, bracket_number_1: 2, bracket_number_2: 2, odds: 222.22),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 1, bracket_number_2: 1, odds: 48.9),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 1, bracket_number_2: 2, odds: 13.8),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 1, bracket_number_2: 3, odds: 26.4),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 1, bracket_number_2: 4, odds: 38.5),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 1, bracket_number_2: 5, odds: 33.2),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 1, bracket_number_2: 6, odds: 11.4),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 1, bracket_number_2: 7, odds: 7.0),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 1, bracket_number_2: 8, odds: 28.6),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 2, bracket_number_2: 2, odds: 102.6),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 2, bracket_number_2: 3, odds: 33.3),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 2, bracket_number_2: 4, odds: 48.4),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 2, bracket_number_2: 5, odds: 41.7),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 2, bracket_number_2: 6, odds: 16.2),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 2, bracket_number_2: 7, odds: 11.0),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 2, bracket_number_2: 8, odds: 46.8),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 3, bracket_number_2: 3, odds: 189.7),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 3, bracket_number_2: 4, odds: 68.2),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 3, bracket_number_2: 5, odds: 65.2),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 3, bracket_number_2: 6, odds: 27.8),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 3, bracket_number_2: 7, odds: 20.3),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 3, bracket_number_2: 8, odds: 66.5),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 4, bracket_number_2: 4, odds: 478.8),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 4, bracket_number_2: 5, odds: 94.7),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 4, bracket_number_2: 6, odds: 37.2),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 4, bracket_number_2: 7, odds: 22.9),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 4, bracket_number_2: 8, odds: 95.0),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 5, bracket_number_2: 5, odds: 445.9),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 5, bracket_number_2: 6, odds: 32.9),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 5, bracket_number_2: 7, odds: 22.4),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 5, bracket_number_2: 8, odds: 66.0),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 6, bracket_number_2: 6, odds: 255.7),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 6, bracket_number_2: 7, odds: 6.2),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 6, bracket_number_2: 8, odds: 28.2),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 7, bracket_number_2: 7, odds: 240.8),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 7, bracket_number_2: 8, odds: 18.3),
          have_attributes(race_meta_id: @meta.id, bracket_number_1: 8, bracket_number_2: 8, odds: 418.7),
        ])
      end
    end

    context "valid page on web" do
      it "parse success" do
        parser = InvestmentHorseRacing::Crawler::Parser::OddsWinPageParser.new(@url, @downloader.download_with_get(@url))

        context = {}

        parser.parse(context)

        expect(context).to be_empty

        expect(InvestmentHorseRacing::Crawler::Model::OddsWin.count).to be > 0
        expect(InvestmentHorseRacing::Crawler::Model::OddsPlace.count).to be > 0
        expect(InvestmentHorseRacing::Crawler::Model::OddsBracketQuinella.count).to be > 0
      end
    end
  end
end
