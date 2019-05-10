require "nokogiri"
require "crawline"

module InvestmentHorseRacing::Crawler::Parser
  class OddsQuinellaPlacePageParser < Crawline::BaseParser
    def initialize(url, data)
      @logger = InvestmentHorseRacing::Crawler::AppLogger.get_logger
      @logger.debug("OddsQuinellaPlacePageParser#initialize: start: url=#{url}, data.size=#{data.size}")

      @data = data

      _parse(url, data)
    end

    def redownload?
      @logger.debug("OddsQuinellaPlacePageParser#redownload?: start")

      (Time.now - @race_meta.start_datetime) < (30 * 24 * 60 * 60)
    end

    def related_links
      @related_links
    end

    def parse(context)
      @logger.debug("OddsQuinellaPlacePageParser#parse: start")

      ActiveRecord::Base.transaction do
        @race_meta.odds_quinella_places.destroy_all
        @logger.debug("OddsQuinellaPlacePageParser#parse: OddsQuinellaPlace(race_meta_id: #{@race_meta.id}) destroy all")

        InvestmentHorseRacing::Crawler::Model::OddsQuinellaPlace.import(@odds_quinella_places)
        @logger.debug("OddsQuinellaPlacePageParser#parse: OddsQuinellaPlace(count: #{@odds_quinella_places.count}) saved")
      end
    end

    private

    def _parse(url, data)
      @logger.debug("OddsQuinellaPlacePageParser#_parse: start")

      race_id = url.match(/^.+?\/odds\/wide\/([0-9]+)\/$/)[1]
      @race_meta = InvestmentHorseRacing::Crawler::Model::RaceMeta.find_by(race_id: race_id)
      raise "RaceMeta(race_id: #{race_id}) not found." if @race_meta.nil?
      @logger.debug("OddsQuinellaPlacePageParser#_parse: race_meta.id=#{@race_meta.id}")

      doc = Nokogiri::HTML.parse(data["response_body"], nil, "UTF-8")

      current_horse_number = nil
      @odds_quinella_places = []

      doc.xpath("//table[contains(@class,'oddsWLs')]/tbody/tr").each do |tr|
        @logger.debug("OddsQuinellaPlacePageParser#_parse: tr=#{tr}")

        if not tr.at_xpath("th[contains(@class,'oddsWJk')]").nil?
          current_horse_number = tr.at_xpath("th").text.strip.to_i
        else
          odds_quinella_place = InvestmentHorseRacing::Crawler::Model::OddsQuinellaPlace.new(
            race_meta: @race_meta,
            horse_number_1: current_horse_number,
            horse_number_2: tr.at_xpath("th").text.strip.to_i,
            odds_1: tr.at_xpath("td[1]").text.strip.to_f,
            odds_2: tr.at_xpath("td[3]").text.strip.to_f)

          @odds_quinella_places << odds_quinella_place
        end
      end

      @related_links = doc.xpath("//div[@id='raceNavi2']/ul/li").map do |li|
        if not li.children[0]["href"].nil?
          li.children[0]["href"].match(/^(\/odds\/.+?\/[0-9]+\/).*$/) do |path|
            @logger.debug("OddsQuinellaPlacePageParser#_parse: path=#{path.inspect}")
            URI.join(url, path[1]).to_s
          end
        end
      end

      @related_links.compact!

      @related_links.each do |related_link|
        @logger.debug("OddsQuinellaPlacePageParser#_parse: related_link=#{related_link}")
      end
    end
  end
end

module InvestmentHorseRacing::Crawler::Model
  class OddsQuinellaPlace < ActiveRecord::Base
    belongs_to :race_meta

    validates :race_meta, presence: true
  end
end
