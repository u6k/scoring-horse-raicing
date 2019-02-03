require "timecop"

require "spec_helper"

RSpec.describe ScoringHorseRacing::Parser::HorsePageParser do
  before do
    # "monte-ruth" horse page parser
    url = "https://keiba.yahoo.co.jp/directory/horse/2015103590/"
    data = File.open("spec/data/horse.2015103590.html").read

    @parser = ScoringHorseRacing::Parser::HorsePageParser.new(url, data)

    # error page parser
    url = "https://keiba.yahoo.co.jp/directory/horse/0000000000/"
    data = File.open("spec/data/horse.0000000000.html").read

    @parser_error = ScoringHorseRacing::Parser::HorsePageParser.new(url, data)
  end

  describe "#redownload?" do
    context "within 1 month from last download" do
      it "do not redownload" do
        Timecop.freeze(Time.local(2018, 7, 24)) do
          expect(@parser).not_to be_redownload
        end
      end
    end

    context "1 month or more after the last download" do
      it "redownload" do
        # TODO: #6761 temporarily implement so as not to redownload
        Timecop.freeze(Time.local(2018, 7, 25)) do
          expect(@parser).not_to be_redownload
        end
      end
    end
  end

  describe "#valid?" do
    context "monte-ruth horse page" do
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
    it "is trainer page" do
      expect(@parser.related_links).to contain_exactly(
        "https://keiba.yahoo.co.jp/directory/trainer/01157/")
    end
  end

  describe "#parse" do
    it "is horse info" do
      context = {}

      @parser.parse(context)

      # TODO: Parse all horse info
      expect(context).to match(
        "horses" => {
          "2015103590" => {
            "horse_id" => "2015103590",
            "gender" => "牝",
            "name" => "モンテルース",
            "date_of_birth" => Time.local(2015, 3, 12),
            "coat_color" => "黒鹿毛",
            "trainer_id" => "01157",
            "owner" => "有限会社 高昭牧場",
            "breeder" => "高昭牧場",
            "breeding_center" => "浦河町"
          }
        }
      )
    end
  end
end









# RSpec.describe "horse page spec" do

#   before do
#     @downloader = ScoringHorseRacing::SpecUtil.build_downloader

#     @repo = ScoringHorseRacing::SpecUtil.build_resource_repository
#     @repo.remove_s3_objects
#   end

#   it "download" do
#     # setup
#     entry_page_html = File.open("spec/data/entry.20180624.hanshin.1.html").read
#     entry_page = ScoringHorseRacing::Rule::EntryPage.new("1809030801", entry_page_html, @downloader, @repo)

#     # execute - new
#     entries = entry_page.entries

#     # check
#     expect(entries.length).to eq 16

#     horse_page = entries[0][:horse]
#     expect(horse_page.horse_id).to eq "2015104308"
#     expect(horse_page.horse_name).to be nil
#     expect(horse_page.valid?).to be_falsey
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[1][:horse]
#     expect(horse_page.horse_id).to eq "2015104964"
#     expect(horse_page.horse_name).to be nil
#     expect(horse_page.valid?).to be_falsey
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[2][:horse]
#     expect(horse_page.horse_id).to eq "2015100632"
#     expect(horse_page.horse_name).to be nil
#     expect(horse_page.valid?).to be_falsey
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[3][:horse]
#     expect(horse_page.horse_id).to eq "2015100586"
#     expect(horse_page.horse_name).to be nil
#     expect(horse_page.valid?).to be_falsey
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[4][:horse]
#     expect(horse_page.horse_id).to eq "2015103335"
#     expect(horse_page.horse_name).to be nil
#     expect(horse_page.valid?).to be_falsey
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[5][:horse]
#     expect(horse_page.horse_id).to eq "2015104928"
#     expect(horse_page.horse_name).to be nil
#     expect(horse_page.valid?).to be_falsey
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[6][:horse]
#     expect(horse_page.horse_id).to eq "2015106259"
#     expect(horse_page.horse_name).to be nil
#     expect(horse_page.valid?).to be_falsey
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[7][:horse]
#     expect(horse_page.horse_id).to eq "2015102694"
#     expect(horse_page.horse_name).to be nil
#     expect(horse_page.valid?).to be_falsey
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[8][:horse]
#     expect(horse_page.horse_id).to eq "2015102837"
#     expect(horse_page.horse_name).to be nil
#     expect(horse_page.valid?).to be_falsey
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[9][:horse]
#     expect(horse_page.horse_id).to eq "2015105363"
#     expect(horse_page.horse_name).to be nil
#     expect(horse_page.valid?).to be_falsey
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[10][:horse]
#     expect(horse_page.horse_id).to eq "2015101618"
#     expect(horse_page.horse_name).to be nil
#     expect(horse_page.valid?).to be_falsey
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[11][:horse]
#     expect(horse_page.horse_id).to eq "2015102853"
#     expect(horse_page.horse_name).to be nil
#     expect(horse_page.valid?).to be_falsey
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[12][:horse]
#     expect(horse_page.horse_id).to eq "2015103462"
#     expect(horse_page.horse_name).to be nil
#     expect(horse_page.valid?).to be_falsey
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[13][:horse]
#     expect(horse_page.horse_id).to eq "2015103590"
#     expect(horse_page.horse_name).to be nil
#     expect(horse_page.valid?).to be_falsey
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[14][:horse]
#     expect(horse_page.horse_id).to eq "2015104979"
#     expect(horse_page.horse_name).to be nil
#     expect(horse_page.valid?).to be_falsey
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[15][:horse]
#     expect(horse_page.horse_id).to eq "2015103557"
#     expect(horse_page.horse_name).to be nil
#     expect(horse_page.valid?).to be_falsey
#     expect(horse_page.exists?).to be_falsey

#     # execute - download
#     entries.each { |e| e[:horse].download_from_web! }

#     # check
#     expect(entries.length).to eq 16

#     horse_page = entries[0][:horse]
#     expect(horse_page.horse_id).to eq "2015104308"
#     expect(horse_page.horse_name).to eq "プロネルクール"
#     expect(horse_page.valid?).to be_truthy
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[1][:horse]
#     expect(horse_page.horse_id).to eq "2015104964"
#     expect(horse_page.horse_name).to eq "スーブレット"
#     expect(horse_page.valid?).to be_truthy
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[2][:horse]
#     expect(horse_page.horse_id).to eq "2015100632"
#     expect(horse_page.horse_name).to eq "アデル"
#     expect(horse_page.valid?).to be_truthy
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[3][:horse]
#     expect(horse_page.horse_id).to eq "2015100586"
#     expect(horse_page.horse_name).to eq "ヤマニンフィオッコ"
#     expect(horse_page.valid?).to be_truthy
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[4][:horse]
#     expect(horse_page.horse_id).to eq "2015103335"
#     expect(horse_page.horse_name).to eq "メイショウハニー"
#     expect(horse_page.valid?).to be_truthy
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[5][:horse]
#     expect(horse_page.horse_id).to eq "2015104928"
#     expect(horse_page.horse_name).to eq "レンブランサ"
#     expect(horse_page.valid?).to be_truthy
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[6][:horse]
#     expect(horse_page.horse_id).to eq "2015106259"
#     expect(horse_page.horse_name).to eq "アンジェレッタ"
#     expect(horse_page.valid?).to be_truthy
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[7][:horse]
#     expect(horse_page.horse_id).to eq "2015102694"
#     expect(horse_page.horse_name).to eq "テーオーパートナー"
#     expect(horse_page.valid?).to be_truthy
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[8][:horse]
#     expect(horse_page.horse_id).to eq "2015102837"
#     expect(horse_page.horse_name).to eq "ウインタイムリープ"
#     expect(horse_page.valid?).to be_truthy
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[9][:horse]
#     expect(horse_page.horse_id).to eq "2015105363"
#     expect(horse_page.horse_name).to eq "モリノマリン"
#     expect(horse_page.valid?).to be_truthy
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[10][:horse]
#     expect(horse_page.horse_id).to eq "2015101618"
#     expect(horse_page.horse_name).to eq "プロムクイーン"
#     expect(horse_page.valid?).to be_truthy
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[11][:horse]
#     expect(horse_page.horse_id).to eq "2015102853"
#     expect(horse_page.horse_name).to eq "ナイスドゥ"
#     expect(horse_page.valid?).to be_truthy
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[12][:horse]
#     expect(horse_page.horse_id).to eq "2015103462"
#     expect(horse_page.horse_name).to eq "アクアレーヌ"
#     expect(horse_page.valid?).to be_truthy
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[13][:horse]
#     expect(horse_page.horse_id).to eq "2015103590"
#     expect(horse_page.horse_name).to eq "モンテルース"
#     expect(horse_page.valid?).to be_truthy
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[14][:horse]
#     expect(horse_page.horse_id).to eq "2015104979"
#     expect(horse_page.horse_name).to eq "リーズン"
#     expect(horse_page.valid?).to be_truthy
#     expect(horse_page.exists?).to be_falsey

#     horse_page = entries[15][:horse]
#     expect(horse_page.horse_id).to eq "2015103557"
#     expect(horse_page.horse_name).to eq "スマートスピカ"
#     expect(horse_page.valid?).to be_truthy
#     expect(horse_page.exists?).to be_falsey

#     # execute - save
#     entries.each { |e| e[:horse].save! }

#     # check
#     entries.each do |e|
#       expect(e[:horse].valid?).to be_truthy
#       expect(e[:horse].exists?).to be_truthy
#     end

#     # execute - re-new
#     entry_page = ScoringHorseRacing::Rule::EntryPage.new("1809030801", entry_page_html, @downloader, @repo)
#     entries_2 = entry_page.entries

#     # check
#     expect(entries_2.length).to eq 16

#     horse_page_2 = entries_2[0][:horse]
#     expect(horse_page_2.horse_id).to eq "2015104308"
#     expect(horse_page_2.horse_name).to be nil
#     expect(horse_page_2.valid?).to be_falsey
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[1][:horse]
#     expect(horse_page_2.horse_id).to eq "2015104964"
#     expect(horse_page_2.horse_name).to be nil
#     expect(horse_page_2.valid?).to be_falsey
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[2][:horse]
#     expect(horse_page_2.horse_id).to eq "2015100632"
#     expect(horse_page_2.horse_name).to be nil
#     expect(horse_page_2.valid?).to be_falsey
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[3][:horse]
#     expect(horse_page_2.horse_id).to eq "2015100586"
#     expect(horse_page_2.horse_name).to be nil
#     expect(horse_page_2.valid?).to be_falsey
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[4][:horse]
#     expect(horse_page_2.horse_id).to eq "2015103335"
#     expect(horse_page_2.horse_name).to be nil
#     expect(horse_page_2.valid?).to be_falsey
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[5][:horse]
#     expect(horse_page_2.horse_id).to eq "2015104928"
#     expect(horse_page_2.horse_name).to be nil
#     expect(horse_page_2.valid?).to be_falsey
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[6][:horse]
#     expect(horse_page_2.horse_id).to eq "2015106259"
#     expect(horse_page_2.horse_name).to be nil
#     expect(horse_page_2.valid?).to be_falsey
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[7][:horse]
#     expect(horse_page_2.horse_id).to eq "2015102694"
#     expect(horse_page_2.horse_name).to be nil
#     expect(horse_page_2.valid?).to be_falsey
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[8][:horse]
#     expect(horse_page_2.horse_id).to eq "2015102837"
#     expect(horse_page_2.horse_name).to be nil
#     expect(horse_page_2.valid?).to be_falsey
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[9][:horse]
#     expect(horse_page_2.horse_id).to eq "2015105363"
#     expect(horse_page_2.horse_name).to be nil
#     expect(horse_page_2.valid?).to be_falsey
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[10][:horse]
#     expect(horse_page_2.horse_id).to eq "2015101618"
#     expect(horse_page_2.horse_name).to be nil
#     expect(horse_page_2.valid?).to be_falsey
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[11][:horse]
#     expect(horse_page_2.horse_id).to eq "2015102853"
#     expect(horse_page_2.horse_name).to be nil
#     expect(horse_page_2.valid?).to be_falsey
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[12][:horse]
#     expect(horse_page_2.horse_id).to eq "2015103462"
#     expect(horse_page_2.horse_name).to be nil
#     expect(horse_page_2.valid?).to be_falsey
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[13][:horse]
#     expect(horse_page_2.horse_id).to eq "2015103590"
#     expect(horse_page_2.horse_name).to be nil
#     expect(horse_page_2.valid?).to be_falsey
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[14][:horse]
#     expect(horse_page_2.horse_id).to eq "2015104979"
#     expect(horse_page_2.horse_name).to be nil
#     expect(horse_page_2.valid?).to be_falsey
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[15][:horse]
#     expect(horse_page_2.horse_id).to eq "2015103557"
#     expect(horse_page_2.horse_name).to be nil
#     expect(horse_page_2.valid?).to be_falsey
#     expect(horse_page_2.exists?).to be_truthy

#     # execute - download from s3
#     entries_2.each { |e| e[:horse].download_from_s3! }

#     # check
#     expect(entries_2.length).to eq 16

#     horse_page_2 = entries_2[0][:horse]
#     expect(horse_page_2.horse_id).to eq "2015104308"
#     expect(horse_page_2.horse_name).to eq "プロネルクール"
#     expect(horse_page_2.valid?).to be_truthy
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[1][:horse]
#     expect(horse_page_2.horse_id).to eq "2015104964"
#     expect(horse_page_2.horse_name).to eq "スーブレット"
#     expect(horse_page_2.valid?).to be_truthy
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[2][:horse]
#     expect(horse_page_2.horse_id).to eq "2015100632"
#     expect(horse_page_2.horse_name).to eq "アデル"
#     expect(horse_page_2.valid?).to be_truthy
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[3][:horse]
#     expect(horse_page_2.horse_id).to eq "2015100586"
#     expect(horse_page_2.horse_name).to eq "ヤマニンフィオッコ"
#     expect(horse_page_2.valid?).to be_truthy
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[4][:horse]
#     expect(horse_page_2.horse_id).to eq "2015103335"
#     expect(horse_page_2.horse_name).to eq "メイショウハニー"
#     expect(horse_page_2.valid?).to be_truthy
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[5][:horse]
#     expect(horse_page_2.horse_id).to eq "2015104928"
#     expect(horse_page_2.horse_name).to eq "レンブランサ"
#     expect(horse_page_2.valid?).to be_truthy
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[6][:horse]
#     expect(horse_page_2.horse_id).to eq "2015106259"
#     expect(horse_page_2.horse_name).to eq "アンジェレッタ"
#     expect(horse_page_2.valid?).to be_truthy
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[7][:horse]
#     expect(horse_page_2.horse_id).to eq "2015102694"
#     expect(horse_page_2.horse_name).to eq "テーオーパートナー"
#     expect(horse_page_2.valid?).to be_truthy
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[8][:horse]
#     expect(horse_page_2.horse_id).to eq "2015102837"
#     expect(horse_page_2.horse_name).to eq "ウインタイムリープ"
#     expect(horse_page_2.valid?).to be_truthy
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[9][:horse]
#     expect(horse_page_2.horse_id).to eq "2015105363"
#     expect(horse_page_2.horse_name).to eq "モリノマリン"
#     expect(horse_page_2.valid?).to be_truthy
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[10][:horse]
#     expect(horse_page_2.horse_id).to eq "2015101618"
#     expect(horse_page_2.horse_name).to eq "プロムクイーン"
#     expect(horse_page_2.valid?).to be_truthy
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[11][:horse]
#     expect(horse_page_2.horse_id).to eq "2015102853"
#     expect(horse_page_2.horse_name).to eq "ナイスドゥ"
#     expect(horse_page_2.valid?).to be_truthy
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[12][:horse]
#     expect(horse_page_2.horse_id).to eq "2015103462"
#     expect(horse_page_2.horse_name).to eq "アクアレーヌ"
#     expect(horse_page_2.valid?).to be_truthy
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[13][:horse]
#     expect(horse_page_2.horse_id).to eq "2015103590"
#     expect(horse_page_2.horse_name).to eq "モンテルース"
#     expect(horse_page_2.valid?).to be_truthy
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[14][:horse]
#     expect(horse_page_2.horse_id).to eq "2015104979"
#     expect(horse_page_2.horse_name).to eq "リーズン"
#     expect(horse_page_2.valid?).to be_truthy
#     expect(horse_page_2.exists?).to be_truthy

#     horse_page_2 = entries_2[15][:horse]
#     expect(horse_page_2.horse_id).to eq "2015103557"
#     expect(horse_page_2.horse_name).to eq "スマートスピカ"
#     expect(horse_page_2.valid?).to be_truthy
#     expect(horse_page_2.exists?).to be_truthy

#     # execute - overwrite
#     entries_2.each { |e| e[:horse].save! }
#   end

#   it "download: invalid page" do
#     # execute - new invalid page
#     horse_page = ScoringHorseRacing::Rule::HorsePage.new("0000000000", nil, @downloader, @repo)

#     # check
#     expect(horse_page.horse_id).to eq "0000000000"
#     expect(horse_page.horse_name).to be nil
#     expect(horse_page.valid?).to be_falsey
#     expect(horse_page.exists?).to be_falsey

#     # execute - download -> fail
#     horse_page.download_from_web!

#     # check
#     expect(horse_page.horse_id).to eq "0000000000"
#     expect(horse_page.horse_name).to be nil
#     expect(horse_page.valid?).to be_falsey
#     expect(horse_page.exists?).to be_falsey

#     # execute - save -> fail
#     expect { horse_page.save! }.to raise_error "Invalid"

#     # check
#     expect(horse_page.horse_id).to eq "0000000000"
#     expect(horse_page.horse_name).to be nil
#     expect(horse_page.valid?).to be_falsey
#     expect(horse_page.exists?).to be_falsey
#   end

#   it "parse" do
#     # setup
#     horse_page_html = File.open("spec/data/horse.2015104308.html").read

#     # execute - new and parse
#     horse_page = ScoringHorseRacing::Rule::HorsePage.new("2015104308", horse_page_html, @downloader, @repo)

#     # check
#     expect(horse_page.horse_id).to eq "2015104308"
#     expect(horse_page.horse_name).to eq "プロネルクール"
#     expect(horse_page.valid?).to be_truthy
#     expect(horse_page.exists?).to be_falsey
#   end

#   it "parse: invalid html" do
#     # execute - new invalid html
#     horse_page = ScoringHorseRacing::Rule::HorsePage.new("0000000000", "Invalid html", @downloader, @repo)

#     # check
#     expect(horse_page.horse_id).to eq "0000000000"
#     expect(horse_page.horse_name).to be nil
#     expect(horse_page.valid?).to be_falsey
#     expect(horse_page.exists?).to be_falsey
#   end

#   it "save, and overwrite" do
#     # setup
#     horse_page_html = File.open("spec/data/horse.2015104308.html").read

#     # execute - new and parse
#     horse_page = ScoringHorseRacing::Rule::HorsePage.new("2015104308", horse_page_html, @downloader, @repo)

#     # check
#     expect(horse_page.horse_id).to eq "2015104308"
#     expect(horse_page.horse_name).to eq "プロネルクール"
#     expect(horse_page.valid?).to be_truthy
#     expect(horse_page.exists?).to be_falsey

#     # save
#     horse_page.save!

#     # check
#     expect(horse_page.valid?).to be_truthy
#     expect(horse_page.exists?).to be_truthy

#     # execute - re-download from web
#     horse_page.download_from_web!

#     # check
#     expect(horse_page.valid?).to be_truthy
#     expect(horse_page.exists?).to be_truthy

#     # execute - save
#     horse_page.save!

#     # check
#     expect(horse_page.valid?).to be_truthy
#     expect(horse_page.exists?).to be_truthy
#   end

# end
