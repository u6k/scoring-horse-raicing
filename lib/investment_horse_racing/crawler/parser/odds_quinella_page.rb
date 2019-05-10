require "nokogiri"
require "crawline"

module InvestmentHorseRacing::Crawler::Parser
  class OddsQuinellaPageParser < Crawline::BaseParser
    def initialize(url, data)
      @logger = InvestmentHorseRacing::Crawler::AppLogger.get_logger
      @logger.debug("OddsQuinellaPageParser#initialize: start: url=#{url}, data.size=#{data.size}")

      @data = data

      _parse(url, data)
    end

    def redownload?
      @logger.debug("OddsQuinellaPageParser#redownload?: start")

      (Time.now - @race_meta.start_datetime) < (30 * 24 * 60 * 60)
    end

    def related_links
      @related_links
    end

    def parse(context)
      @logger.debug("OddsQuinellaPageParser#parse: start")

      ActiveRecord::Base.transaction do
        @race_meta.odds_quinellas.destroy_all
        @logger.debug("OddsQuinellaPageParser#parse: OddsQuinella(race_meta_id: #{@race_meta.id}) destroy all")

        InvestmentHorseRacing::Crawler::Model::OddsQuinella.import(@odds_quinellas)
        @logger.debug("OddsQuinellaPageParser#parse: OddsQuinella(count: #{@odds_quinellas.count}) saved")
      end
    end

    private

    def _parse(url, data)
      @logger.debug("OddsQuinellaPageParser#_parse: start")

      race_id = url.match(/^.+?\/odds\/ur\/([0-9]+)\/$/)[1]
      @race_meta = InvestmentHorseRacing::Crawler::Model::RaceMeta.find_by(race_id: race_id)
      raise "RaceMeta(race_id: #{race_id}) not found." if @race_meta.nil?
      @logger.debug("OddsQuinellaPageParser#_parse: race_meta.id=#{@race_meta.id}")

      doc = Nokogiri::HTML.parse(data["response_body"], nil, "UTF-8")

      current_horse_number = nil
      @odds_quinellas = []

      doc.xpath("//table[contains(@class,'oddsLs')]/tbody/tr").each do |tr|
        @logger.debug("OddsQuinellaPageParser#_parser: tr=#{tr}")

        if not tr.at_xpath("th[contains(@class,'oddsJk')]").nil?
          current_horse_number = tr.at_xpath("th[contains(@class,'oddsJk')]").text.strip.to_i
        else
          odds_quinella = InvestmentHorseRacing::Crawler::Model::OddsQuinella.new(
            race_meta: @race_meta,
            horse_number_1: current_horse_number,
            horse_number_2: tr.at_xpath("th").text.strip.to_i,
            odds: tr.at_xpath("td").text.strip.to_f)

          @odds_quinellas << odds_quinella
        end
      end

      @related_links = doc.xpath("//div[@id='raceNavi2']/ul/li").map do |li|
        if not li.children[0]["href"].nil?
          li.children[0]["href"].match(/^(\/odds\/.+?\/[0-9]+\/).*$/) do |path|
            @logger.debug("OddsQuinellaPageParser#_parse: path=#{path.inspect}")
            URI.join(url, path[1]).to_s
          end
        end
      end

      @related_links.compact!

      @related_links.each do |related_link|
        @logger.debug("OddsQuinellaPageParser#_parse: related_link=#{related_link}")
      end
    end
  end
end

module InvestmentHorseRacing::Crawler::Model
  class OddsQuinella < ActiveRecord::Base
    belongs_to :race_meta

    validates :race_meta, presence: true
  end
end
