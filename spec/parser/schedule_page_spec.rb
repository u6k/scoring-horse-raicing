require "timecop"

require "spec_helper"

RSpec.describe ScoringHorseRacing::Parser::SchedulePageParser do
  before do
    url = "https://keiba.yahoo.co.jp/schedule/list/2018/?month=06"
    data = File.open("spec/data/schedule.201806.html").read

    @parser = ScoringHorseRacing::Parser::SchedulePageParser.new(url, data)
  end

  describe "#redownload?" do
    it "redownload if newer than 2 months" do
      Timecop.freeze(Time.local(2018, 8, 31)) do
        expect(@parser).to be_redownload
      end
    end

    it "do not redownload if over 3 months old" do
      Timecop.freeze(Time.local(2018, 9, 1)) do
        expect(@parser).not_to be_redownload
      end
    end
  end

  describe "#valid?" do
    context "2018-06 schedule page" do
      it "is valid" do
        expect(@parser).to be_valid
      end
    end

    context "error page" do
      before do
        url = "https://keiba.yahoo.co.jp/schedule/list/1900/?month=01"
        data = File.open("spec/data/schedule.190001.html").read

        @parser = ScoringHorseRacing::Parser::SchedulePageParser.new(url, data)
      end

      it "is invalid" do
        expect(@parser).not_to be_valid
      end
    end
  end

  describe "#related_links" do
    context "2018-06 schedule page" do
      it "is race list pages" do
        expect(@parser.related_links).to contain_exactly(
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
      before do
        url = "https://keiba.yahoo.co.jp/schedule/list/2018/?month=08"
        data = File.open("spec/data/schedule.201808.html").read

        @parser = ScoringHorseRacing::Parser::SchedulePageParser.new(url, data)
      end

      it "is race list pages" do
        expect(@parser.related_links).to contain_exactly(
          "https://keiba.yahoo.co.jp/race/list/18010103/",
          "https://keiba.yahoo.co.jp/race/list/18040203/",
          "https://keiba.yahoo.co.jp/race/list/18100203/",
          "https://keiba.yahoo.co.jp/race/list/18010104/",
          "https://keiba.yahoo.co.jp/race/list/18040204/",
          "https://keiba.yahoo.co.jp/race/list/18100204/")
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

