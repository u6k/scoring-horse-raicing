require "nokogiri"
require "crawline"

module InvestmentHorseRacing::Crawler::Parser
  class OddsTrifectaPageParser < Crawline::BaseParser
    def initialize(url, data)
      @logger = InvestmentHorseRacing::Crawler::AppLogger.get_logger
      @logger.debug("OddsTrifectaPageParser#initialize: start: url=#{url}, data.size=#{data.size}")

      @data = data

      _parse(url, data)
    end

    def redownload?
      @logger.debug("OddsTrifectaPageParser#redownload?: start")

      (Time.now - @race_meta.start_datetime) < (30 * 24 * 60 * 60)
    end

    def related_links
      @related_links
    end

    def parse(context)
      @logger.debug("OddsTrifectaPageParser#parse: start")

      ActiveRecord::Base.transaction do
        @race_meta.odds_trifectas.where(horse_number_1: @odds_trifectas[0].horse_number_1).destroy_all
        @logger.debug("OddsTrifectaPageParser#parse: OddsTrifecta(race_meta_id: #{@race_meta.id}, horse_number_1: #{@odds_trifectas[0].horse_number_1}) destroy all")

        InvestmentHorseRacing::Crawler::Model::OddsTrifecta.import(@odds_trifectas)
        @logger.debug("OddsTrifectaPageParser#parse: OddsTrifecta(count: #{@odds_trifectas.count}) saved")
      end
    end

    private

    def _parse(url, data)
      @logger.debug("OddsTrifectaPageParser#_parse: start")

      race_id = url.match(/^.+?\/odds\/st\/([0-9]+)\/(\?umaBan=([0-9]+))?$/)[1]
      @race_meta = InvestmentHorseRacing::Crawler::Model::RaceMeta.find_by(race_id: race_id)
      raise "RaceMeta(race_id: #{race_id}) not found." if @race_meta.nil?
      @logger.debug("OddsTrifectaPageParser#_parse: race_meta.id=#{@race_meta.id}")

      doc = Nokogiri::HTML.parse(data["response_body"], nil, "UTF-8")

      @odds_trifectas = doc.xpath("//table[@class='odds3TLs']/tbody/tr[position()>1]").map do |tr|
        parts = tr.at_xpath("th").text.split("－")

        odds_trifecta = InvestmentHorseRacing::Crawler::Model::OddsTrifecta.new(
          race_meta: @race_meta,
          horse_number_1: parts[0].to_i,
          horse_number_2: parts[1].to_i,
          horse_number_3: parts[2].to_i,
          odds: tr.at_xpath("td").text.strip.to_f)
      end

      @related_links = doc.xpath("//div[@id='raceNavi2']/ul/li").map do |li|
        if not li.children[0]["href"].nil?
          li.children[0]["href"].match(/^(\/odds\/.+?\/[0-9]+\/).*$/) do |path|
            @logger.debug("OddsTrifectaPageParser#_parse: path=#{path.inspect}")
            URI.join(url, path[1]).to_s
          end
        end
      end

      @related_links += doc.xpath("//select[@name='umaBan']/option").map do |option|
        URI.join(url, "?umaBan=#{option["value"]}").to_s if option["selected"].nil?
      end

      @related_links.compact!

      @related_links.each do |related_link|
        @logger.debug("OddsTrifectaPageParser#_parse: related_link=#{related_link}")
      end
    end
  end
end

module InvestmentHorseRacing::Crawler::Model
  class OddsTrifecta < ActiveRecord::Base
    belongs_to :race_meta

    validates :race_meta, presence: true
  end
end
