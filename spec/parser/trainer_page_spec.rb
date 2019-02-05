require "timecop"

require "spec_helper"

RSpec.describe ScoringHorseRacing::Parser::TrainerPageParser do
  before do
    # "haruki-sugiyama" trainer page parser
    url = "https://keiba.yahoo.co.jp/directory/trainer/01157/"
    data = File.open("spec/data/trainer.01157.html").read

    @parser = ScoringHorseRacing::Parser::TrainerPageParser.new(url, data)

    # error page parser
    url = "https://keiba.yahoo.co.jp/directory/trainer/00000/"
    data = File.open("spec/data/trainer.00000.html").read

    @parser_error = ScoringHorseRacing::Parser::TrainerPageParser.new(url, data)
  end

  describe "#redownload?" do
    context "within 1 month from last download" do
      it "do not redownload" do
        Timecop.freeze(Time.local(2018, 7, 24)) do
          expect(@parser).not_to be_redownload
        end
      end
    end

    context "1 month or more after last download" do
      it "redownload" do
        # TODO: #6761 temporarily implement so as not to redownload
        Timecop.freeze(Time.local(2018, 7, 25)) do
          expect(@parser).not_to be_redownload
        end
      end
    end
  end

  describe "#valid?" do
    context "haruki-sugiyama trainer page" do
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
    it "is empty" do
      expect(@parser.related_links).to be_empty
    end
  end

  describe "#parse" do
    it "is trainer info" do
      context = {}

      @parser.parse(context)

      # TODO: Parse all jockey info
      expect(context).to match(
        "trainers" => {
          "01157" => {
            "trainer_id" => "01157",
            "name" => "杉山 晴紀",
            "name_kana" => "スギヤマ ハルキ",
            "date_of_birth" => Time.local(1981, 12, 24),
            "affiliation" => "栗東"
          }
        })
    end
  end
end
