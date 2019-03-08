require "timecop"

require "spec_helper"

RSpec.describe ScoringHorseRacing::Parser::SchedulePageParser do
  before do
    # 2018-06 schedule page parser
    url = "https://keiba.yahoo.co.jp/schedule/list/2018/?month=06"
    data = File.open("spec/data/schedule.201806.html").read

    @parser = ScoringHorseRacing::Parser::SchedulePageParser.new(url, data)

    # 2018-08 schedule page (case link is incomplete) parser
    url = "https://keiba.yahoo.co.jp/schedule/list/2018/?month=08"
    data = File.open("spec/data/schedule.201808.html").read

    @parser_201808 = ScoringHorseRacing::Parser::SchedulePageParser.new(url, data)

    # 1986-01 schedule page parser
    url = "https://keiba.yahoo.co.jp/schedule/list/1986/?month=01"
    data = File.open("spec/data/schedule.198601.html").read

    @parser_198601 = ScoringHorseRacing::Parser::SchedulePageParser.new(url, data)

    # error page parser
    url = "https://keiba.yahoo.co.jp/schedule/list/1900/?month=01"
    data = File.open("spec/data/schedule.190001.html").read

    @parser_error = ScoringHorseRacing::Parser::SchedulePageParser.new(url, data)
  end

  describe "#redownload?" do
    context "2018-06 schedule page" do
      it "redownload if newer than 2 months" do
        Timecop.freeze(Time.local(2018, 8, 29)) do
          expect(@parser).to be_redownload
        end
      end

      it "do not redownload if over 3 months old" do
        Timecop.freeze(Time.local(2018, 8, 30)) do
          expect(@parser).not_to be_redownload
        end
      end
    end
  end

  describe "#valid?" do
    context "2018-06 schedule page" do
      it "is valid" do
        expect(@parser).to be_valid
      end
    end

    context "2018-08 schedule page" do
      it "is valid" do
        expect(@parser_201808).to be_valid
      end
    end

    context "error page" do
      it "is invalid" do
        expect(@parser_error).not_to be_valid
      end
    end
  end

  describe "#related_links" do
    context "2018-06 schedule page" do
      it "is race list pages, and schedule list pages" do
        expect(@parser.related_links).to contain_exactly(
          "https://keiba.yahoo.co.jp/schedule/list/2017/?month=12",
          "https://keiba.yahoo.co.jp/schedule/list/2018/?month=1",
          "https://keiba.yahoo.co.jp/schedule/list/2018/?month=2",
          "https://keiba.yahoo.co.jp/schedule/list/2018/?month=3",
          "https://keiba.yahoo.co.jp/schedule/list/2018/?month=4",
          "https://keiba.yahoo.co.jp/schedule/list/2018/?month=5",
          "https://keiba.yahoo.co.jp/schedule/list/2018/?month=7",
          "https://keiba.yahoo.co.jp/schedule/list/2018/?month=8",
          "https://keiba.yahoo.co.jp/schedule/list/2018/?month=9",
          "https://keiba.yahoo.co.jp/schedule/list/2018/?month=10",
          "https://keiba.yahoo.co.jp/schedule/list/2018/?month=11",
          "https://keiba.yahoo.co.jp/schedule/list/2018/?month=12",
          "https://keiba.yahoo.co.jp/race/list/18050301/",
          "https://keiba.yahoo.co.jp/race/list/18090301/",
          "https://keiba.yahoo.co.jp/race/list/18050302/",
          "https://keiba.yahoo.co.jp/race/list/18090302/",
          "https://keiba.yahoo.co.jp/race/list/18050303/",
          "https://keiba.yahoo.co.jp/race/list/18090303/",
          "https://keiba.yahoo.co.jp/race/list/18050304/",
          "https://keiba.yahoo.co.jp/race/list/18090304/",
          "https://keiba.yahoo.co.jp/race/list/18020101/",
          "https://keiba.yahoo.co.jp/race/list/18050305/",
          "https://keiba.yahoo.co.jp/race/list/18090305/",
          "https://keiba.yahoo.co.jp/race/list/18020102/",
          "https://keiba.yahoo.co.jp/race/list/18050306/",
          "https://keiba.yahoo.co.jp/race/list/18090306/",
          "https://keiba.yahoo.co.jp/race/list/18020103/",
          "https://keiba.yahoo.co.jp/race/list/18050307/",
          "https://keiba.yahoo.co.jp/race/list/18090307/",
          "https://keiba.yahoo.co.jp/race/list/18020104/",
          "https://keiba.yahoo.co.jp/race/list/18050308/",
          "https://keiba.yahoo.co.jp/race/list/18090308/",
          "https://keiba.yahoo.co.jp/race/list/18020105/",
          "https://keiba.yahoo.co.jp/race/list/18030201/",
          "https://keiba.yahoo.co.jp/race/list/18070301/")
      end
    end

    context "2018-08 schedule page (case link is incomplete)" do
      it "is race list pages, and schedule list pages" do
        expect(@parser_201808.related_links).to contain_exactly(
          "https://keiba.yahoo.co.jp/schedule/list/2017/?month=12",
          "https://keiba.yahoo.co.jp/schedule/list/2018/?month=1",
          "https://keiba.yahoo.co.jp/schedule/list/2018/?month=2",
          "https://keiba.yahoo.co.jp/schedule/list/2018/?month=3",
          "https://keiba.yahoo.co.jp/schedule/list/2018/?month=4",
          "https://keiba.yahoo.co.jp/schedule/list/2018/?month=5",
          "https://keiba.yahoo.co.jp/schedule/list/2018/?month=6",
          "https://keiba.yahoo.co.jp/schedule/list/2018/?month=7",
          "https://keiba.yahoo.co.jp/schedule/list/2018/?month=9",
          "https://keiba.yahoo.co.jp/schedule/list/2018/?month=10",
          "https://keiba.yahoo.co.jp/schedule/list/2018/?month=11",
          "https://keiba.yahoo.co.jp/schedule/list/2018/?month=12",
          "https://keiba.yahoo.co.jp/race/list/18010103/",
          "https://keiba.yahoo.co.jp/race/list/18040203/",
          "https://keiba.yahoo.co.jp/race/list/18100203/",
          "https://keiba.yahoo.co.jp/race/list/18010104/",
          "https://keiba.yahoo.co.jp/race/list/18040204/",
          "https://keiba.yahoo.co.jp/race/list/18100204/")
      end
    end

    context "1986-01 schedule page" do
      it "is race list pages, and schedule list pages" do
        expect(@parser_198601.related_links).to contain_exactly(
          "https://keiba.yahoo.co.jp/schedule/list/1986/?month=2",
          "https://keiba.yahoo.co.jp/schedule/list/1986/?month=3",
          "https://keiba.yahoo.co.jp/schedule/list/1986/?month=4",
          "https://keiba.yahoo.co.jp/schedule/list/1986/?month=5",
          "https://keiba.yahoo.co.jp/schedule/list/1986/?month=6",
          "https://keiba.yahoo.co.jp/schedule/list/1986/?month=7",
          "https://keiba.yahoo.co.jp/schedule/list/1986/?month=8",
          "https://keiba.yahoo.co.jp/schedule/list/1986/?month=9",
          "https://keiba.yahoo.co.jp/schedule/list/1986/?month=10",
          "https://keiba.yahoo.co.jp/schedule/list/1986/?month=11",
          "https://keiba.yahoo.co.jp/schedule/list/1986/?month=12",
          "https://keiba.yahoo.co.jp/schedule/list/1987/?month=1",
          "https://keiba.yahoo.co.jp/race/list/86060101/",
          "https://keiba.yahoo.co.jp/race/list/86080101/",
          "https://keiba.yahoo.co.jp/race/list/86060102/",
          "https://keiba.yahoo.co.jp/race/list/86080102/",
          "https://keiba.yahoo.co.jp/race/list/86060103/",
          "https://keiba.yahoo.co.jp/race/list/86080103/",
          "https://keiba.yahoo.co.jp/race/list/86060104/",
          "https://keiba.yahoo.co.jp/race/list/86080104/",
          "https://keiba.yahoo.co.jp/race/list/86060105/",
          "https://keiba.yahoo.co.jp/race/list/86080105/",
          "https://keiba.yahoo.co.jp/race/list/86060106/",
          "https://keiba.yahoo.co.jp/race/list/86080106/",
          "https://keiba.yahoo.co.jp/race/list/86060107/",
          "https://keiba.yahoo.co.jp/race/list/86080107/",
          "https://keiba.yahoo.co.jp/race/list/86060108/",
          "https://keiba.yahoo.co.jp/race/list/86080108/",
          "https://keiba.yahoo.co.jp/race/list/86050101/",
          "https://keiba.yahoo.co.jp/race/list/86070101/",
          "https://keiba.yahoo.co.jp/race/list/86080201/",
          "https://keiba.yahoo.co.jp/race/list/86050102/",
          "https://keiba.yahoo.co.jp/race/list/86070102/",
          "https://keiba.yahoo.co.jp/race/list/86080202/")
      end
    end
  end

  describe "#parse" do
    it "is empty" do
      context = {}

      @parser.parse(context)

      expect(context).to be_empty
    end
  end
end
