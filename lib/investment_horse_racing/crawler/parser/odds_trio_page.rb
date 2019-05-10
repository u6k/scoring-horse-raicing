require "nokogiri"
require "crawline"

module InvestmentHorseRacing::Crawler::Parser
  class OddsTrioPageParser < Crawline::BaseParser
    def initialize(url, data)
      @logger = InvestmentHorseRacing::Crawler::AppLogger.get_logger
      @logger.debug("OddsTrioPageParser#initialize: start: url=#{url}, data.size=#{data.size}")

      @data = data

      _parse(url, data)
    end

    def redownload?
      @logger.debug("OddsTrioPageParser#redownload?: start")

      (Time.now - @race_meta.start_datetime) < (30 * 24 * 60 * 60)
    end

    def related_links
      @related_links
    end

    def parse(context)
      @logger.debug("OddsTrioPageParser#_parse: start")

      ActiveRecord::Base.transaction do
        @race_meta.odds_trios.destroy_all
        @logger.debug("OddsTrioPageParser#_parse: OddsTrio(race_meta_id: #{@race_meta.id}) destroy all")

        InvestmentHorseRacing::Crawler::Model::OddsTrio.import(@odds_trios)
        @logger.debug("OddsTrioPageParser#_parse: OddsTrio(count: #{@odds_trios.count}) saved")
      end
    end

    private

    def _parse(url, data)
      @logger.debug("OddsTrioPageParser#_parse: start")

      race_id = url.match(/^.+?\/odds\/sf\/([0-9]+)\/$/)[1]
      @race_meta = InvestmentHorseRacing::Crawler::Model::RaceMeta.find_by(race_id: race_id)
      raise "RaceMeta(race_id: #{race_id}) not found." if @race_meta.nil?
      @logger.debug("OddsTrioPageParser#_parse: race_meta.id=#{@race_meta.id}")

      doc = Nokogiri::HTML.parse(data["response_body"], nil, "UTF-8")

      current_horse_number_1 = nil
      current_horse_number_2 = nil
      @odds_trios = []

      doc.xpath("//table[@class='oddsLs']/tbody/tr").each do |tr|
        @logger.debug("OddsTrioPageParser#_parse: tr=#{tr}")

        if not tr.at_xpath("th[@class='oddsJk']").nil?
          parts = tr.at_xpath("th").text.strip.split("－")
          current_horse_number_1 = parts[0].to_i
          current_horse_number_2 = parts[1].to_i
        else
          odds_trio = InvestmentHorseRacing::Crawler::Model::OddsTrio.new(
            race_meta: @race_meta,
            horse_number_1: current_horse_number_1,
            horse_number_2: current_horse_number_2,
            horse_number_3: tr.at_xpath("th").text.strip.to_i,
            odds: tr.at_xpath("td").text.strip.to_f)

          @odds_trios << odds_trio
        end
      end

      @related_links = doc.xpath("//div[@id='raceNavi2']/ul/li").map do |li|
        if not li.children[0]["href"].nil?
          li.children[0]["href"].match(/^(\/odds\/.+?\/[0-9]+\/).*$/) do |path|
            @logger.debug("OddsTrioPageParser#_parse: path=#{path.inspect}")
            URI.join(url, path[1]).to_s
          end
        end
      end

      @related_links.compact!

      @related_links.each do |related_link|
        @logger.debug("OddsTrioPageParser#_parse: related_link=#{related_link}")
      end
    end
  end
end

module InvestmentHorseRacing::Crawler::Model
  class OddsTrio < ActiveRecord::Base
    belongs_to :race_meta

    validates :race_meta, presence: true
  end
end
