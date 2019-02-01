require "timecop"

require "spec_helper"

RSpec.describe ScoringHorseRacing::Parser::RaceListPageParser do
  before do
    url = "https://keiba.yahoo.co.jp/race/list/18090308/"
    data = File.open("spec/data/race_list.20180624.hanshin.html").read

    @parser = ScoringHorseRacing::Parser::RaceListPageParser.new(url, data)
  end

  describe "#redownload?" do
    it "redownload if newer than 2 months" do
      Timecop.freeze(Time.local(2018, 9, 23)) do
        expect(@parser).to be_redownload
      end
    end

    it "do not redownload if over 3 months old" do
      Timecop.freeze(Time.local(2018, 9, 24)) do
        expect(@parser).not_to be_redownload
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
      before do
        url = "https://keiba.yahoo.co.jp/race/list/00000000/"
        data = File.open("spec/data/race_list.00000000.error.html").read

        @parser = ScoringHorseRacing::Parser::RaceListPageParser.new(url, data)
      end

      it "is invalid" do
        expect(@parser).not_to be_valid
      end
    end
  end

  describe "#related_links" do
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

  describe "#parse" do
    it "is race info" do
      context = {}

      @parser.parse(context)

      expect(context).to match(
        "races" => {
          "18090308" => {
            "race_id" => "18090308",
            "date" => Date.new(2018, 6, 24),
            "course_name" => "阪神"
          }
        })
    end
  end
end

