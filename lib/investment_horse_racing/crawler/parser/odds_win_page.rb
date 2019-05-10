require "nokogiri"
require "crawline"
require "active_record"
require "activerecord-import"

module InvestmentHorseRacing::Crawler::Parser
  class OddsWinPageParser < Crawline::BaseParser
    def initialize(url, data)
      @logger = InvestmentHorseRacing::Crawler::AppLogger.get_logger
      @logger.debug("OddsWinPageParser#initialize: start: url=#{url}, data.size=#{data.size}")

      @data = data

      _parse(url, data)
    end

    def redownload?
      @logger.debug("OddsWinPageParser#redownload?: start")

      (Time.now - @race_meta.start_datetime) < (30 * 24 * 60 * 60)
    end

    def valid?
      (@title === "単勝・複勝・枠連")
    end

    def related_links
      @related_links
    end

    def parse(context)
      @logger.debug("OddsWinPageParser#parse: start")

      ActiveRecord::Base.transaction do
        @race_meta.odds_wins.destroy_all
        @logger.debug("OddsWinPageParser#parse: OddsWin(race_meta_id: #{@race_meta.id}) destroy all")

        @race_meta.odds_places.destroy_all
        @logger.debug("OddsWinPageParser#parse: OddsPlace(race_meta_id: #{@race_meta.id}) destroy all")

        @race_meta.odds_bracket_quinellas.destroy_all
        @logger.debug("OddsWinPageParser#parse: OddsBracketQuinella(race_meta_id: #{@race_meta.id}) destroy all")

        InvestmentHorseRacing::Crawler::Model::OddsWin.import(@odds_wins)
        @logger.debug("OddsWinPageParser#parse: OddsWin(count: #{@odds_wins.count}) saved")

        InvestmentHorseRacing::Crawler::Model::OddsPlace.import(@odds_places)
        @logger.debug("OddsWinPageParser#parse: OddsPlace(count: #{@odds_places.count}) saved")

        InvestmentHorseRacing::Crawler::Model::OddsBracketQuinella.import(@odds_bracket_quinellas)
        @logger.debug("OddsWinPageParser#parse: OddsBracketQuinella(count: #{@odds_bracket_quinellas.count}) saved")
      end
    end

    private

    def _parse(url, data)
      @logger.debug("OddsWinPageParser#_parse: start")

      race_id = url.match(/^.+?\/odds\/tfw\/([0-9]+)\/$/)[1]
      @race_meta = InvestmentHorseRacing::Crawler::Model::RaceMeta.find_by(race_id: race_id)
      raise "RaceMeta(race_id: #{race_id}) not found." if @race_meta.nil?
      @logger.debug("OddsWinPageParser#_parse: race_meta.id=#{@race_meta.id}")

      doc = Nokogiri::HTML.parse(data["response_body"], nil, "UTF-8")

      @odds_wins = []
      @odds_places = []

      doc.xpath("//table[contains(@class,'oddTkwLs')]/tbody/tr[position()>1]").each do |tr|
        @logger.debug("OddsWinPageParser#_parse: win, place: tr=#{tr}")

        odds_win = InvestmentHorseRacing::Crawler::Model::OddsWin.new(
          race_meta: @race_meta,
          horse_number: tr.at_xpath("td[2]").text.strip.to_i,
          odds: tr.at_xpath("td[4]").text.strip.to_f)

        @odds_wins << odds_win

        odds_place = InvestmentHorseRacing::Crawler::Model::OddsPlace.new(
          race_meta: @race_meta,
          horse_number: tr.at_xpath("td[2]").text.strip.to_i,
          odds_1: tr.at_xpath("td[5]").text.strip.to_f,
          odds_2: tr.at_xpath("td[7]").text.strip.to_f)

        @odds_places << odds_place
      end

      current_bracket_number = nil
      @odds_bracket_quinellas = []

      doc.xpath("//table[contains(@class,'oddsLs')]/tbody/tr").each do |tr|
        @logger.debug("OddsWinPageParser#_parser: bracket quinella: tr=#{tr}")

        if not tr.at_xpath("th[contains(@class,'oddsJk')]").nil?
          current_bracket_number = tr.at_xpath("th[contains(@class,'oddsJk')]/div").text.strip.to_i
        else
          odds_bracket_quinella = InvestmentHorseRacing::Crawler::Model::OddsBracketQuinella.new(
            race_meta: @race_meta,
            bracket_number_1: current_bracket_number,
            bracket_number_2: tr.at_xpath("th").text.strip.to_i,
            odds: tr.at_xpath("td").text.strip.to_f)

          @odds_bracket_quinellas << odds_bracket_quinella
        end
      end

      @related_links = doc.xpath("//div[@id='raceNavi2']/ul/li").map do |li|
        if not li.children[0]["href"].nil?
          li.children[0]["href"].match(/^(\/odds\/.+?\/[0-9]+\/).*$/) do |path|
            @logger.debug("OddsWinPageParser#_parse: path=#{path.inspect}")
            URI.join(url, path[1]).to_s
          end
        end
      end

      @related_links.compact!

      @related_links.each do |related_link|
        @logger.debug("OddsWinPageParser#_parse: related_link=#{related_link}")
      end
    end
  end
end

module InvestmentHorseRacing::Crawler::Model
  class OddsWin < ActiveRecord::Base
    belongs_to :race_meta

    validates :race_meta, presence: true
  end

  class OddsPlace < ActiveRecord::Base
    belongs_to :race_meta

    validates :race_meta, presence: true
  end

  class OddsBracketQuinella < ActiveRecord::Base
    belongs_to :race_meta

    validates :race_meta, presence: true
  end
end
