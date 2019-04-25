require "timecop"

require "spec_helper"

RSpec.describe InvestmentHorseRacing::Crawler::Parser::RaceListPageParser do
  before do
    # 2018-06-24 hanshin race list page parser
    url = "https://keiba.yahoo.co.jp/race/list/18090308/"
    data = {
      "url" => "https://keiba.yahoo.co.jp/race/list/18090308/",
      "request_method" => "GET",
      "request_headers" => {},
      "response_headers" => {},
      "response_body" => File.open("spec/data/race_list.20180624.hanshin.html").read,
      "downloaded_timestamp" => Time.utc(2018, 6, 24, 0, 0, 0)}

    @parser = InvestmentHorseRacing::Crawler::Parser::RaceListPageParser.new(url, data)

    # error page parser
    url = "https://keiba.yahoo.co.jp/race/list/00000000/"
    data = {
      "url" => "https://keiba.yahoo.co.jp/race/list/00000000/",
      "request_method" => "GET",
      "request_headers" => {},
      "response_headers" => {},
      "response_body" => File.open("spec/data/race_list.00000000.error.html").read,
      "downloaded_timestamp" => Time.now}

    @parser_error = InvestmentHorseRacing::Crawler::Parser::RaceListPageParser.new(url, data)
  end

  describe "#redownload?" do
    context "2018-06-24 hanshin race list page" do
      it "redownload if newer than 2 months" do
        Timecop.freeze(Time.local(2018, 9, 21)) do
          expect(@parser).to be_redownload
        end
      end

      it "do not redownload if over 3 months old" do
        Timecop.freeze(Time.local(2018, 9, 22)) do
          expect(@parser).not_to be_redownload
        end
      end

      it "redownload if 1 day has passed" do
        Timecop.freeze(Time.utc(2018, 6, 25, 0, 0, 0)) do
          expect(@parser).to be_redownload
        end
      end

      it "do not redownload within 1 day" do
        Timecop.freeze(Time.utc(2018, 6, 24, 23, 59, 59)) do
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

        expect(context).to match(
          "races" => {
            "18090308" => {
              "race_id" => "18090308",
              "date" => Time.local(2018, 6, 24),
              "course_name" => "阪神"
            }
          })
      end
    end
  end
end
