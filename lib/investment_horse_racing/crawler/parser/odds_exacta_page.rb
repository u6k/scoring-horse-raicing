require "nokogiri"
require "crawline"

module InvestmentHorseRacing::Crawler::Parser
  class OddsExactaPageParser < Crawline::BaseParser
    def initialize(url, data)
      @logger = InvestmentHorseRacing::Crawler::AppLogger.get_logger
      @logger.debug("OddsExactaPageParser#initialize: start: url=#{url}, data.size=#{data.size}")

      @data = data

      _parse(url, data)
    end

    def redownload?
      @logger.debug("OddsExactaPageParser#redownload?: start")

      (Time.now - @race_meta.start_datetime) < (30 * 24 * 60 * 60)
    end

    def related_links
      @related_links
    end

    def parse(context)
      @logger.debug("OddsExactaPageParser#parse: start: start_datetime=#{@race_meta.start_datetime}, race_number=#{@race_meta.race_number}")

      ActiveRecord::Base.transaction do
        @race_meta.odds_exactas.destroy_all
        @logger.debug("OddsExactaPageParser#parse: OddsExacta(race_meta_id: #{@race_meta.id}) destroy all")

        InvestmentHorseRacing::Crawler::Model::OddsExacta.import(@odds_exactas)
        @logger.debug("OddsExactaPageParser#parse: OddsExacta(count: #{@odds_exactas.count}) saved")
      end
    end

    private

    def _parse(url, data)
      @logger.debug("OddsExactaPageParser#_parse: start")

      race_id = url.match(/^.+?\/odds\/ut\/([0-9]+)\/$/)[1]
      @race_meta = InvestmentHorseRacing::Crawler::Model::RaceMeta.find_by(race_id: race_id)
      raise "RaceMeta(race_id: #{race_id}) not found." if @race_meta.nil?
      @logger.debug("OddsExactaPageParser#_parse: race_meta.id=#{@race_meta.id}")

      doc = Nokogiri::HTML.parse(data["response_body"], nil, "UTF-8")

      current_horse_number = nil
      @odds_exactas = []

      doc.xpath("//table[@class='oddsLs']/tbody/tr").each do |tr|
        @logger.debug("OddsExactaPageParser#_parse: tr=#{tr}")

        if not tr.at_xpath("th[@class='oddsJk']").nil?
          current_horse_number = tr.at_xpath("th").text.strip.to_i
        else
          odds_exacta = InvestmentHorseRacing::Crawler::Model::OddsExacta.new(
            race_meta: @race_meta,
            horse_number_1: current_horse_number,
            horse_number_2: tr.at_xpath("th").text.strip.to_i,
            odds: tr.at_xpath("td").text.strip.to_f)

          @odds_exactas << odds_exacta
        end
      end

      @related_links = doc.xpath("//div[@id='raceNavi2']/ul/li").map do |li|
        if not li.children[0]["href"].nil?
          li.children[0]["href"].match(/^(\/odds\/.+?\/[0-9]+\/).*$/) do |path|
            @logger.debug("OddsExactaPageParser#_parse: path=#{path.inspect}")
            URI.join(url, path[1]).to_s
          end
        end
      end

      @related_links.compact!

      @related_links.each do |related_link|
        @logger.debug("OddsExactaPageParser#_parse: related_link=#{related_link}")
      end
    end
  end
end

module InvestmentHorseRacing::Crawler::Model
  class OddsExacta < ActiveRecord::Base
    belongs_to :race_meta

    validates :race_meta, presence: true
  end
end
