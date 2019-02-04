require "nokogiri"
require "crawline"

module ScoringHorseRacing::Parser
  class OddsExactaPageParser < Crawline::BaseParser
    def initialize(url, data)
      @logger = ScoringHorseRacing::AppLogger.get_logger
      @logger.info("OddsExactaPageParser#initialize: start: url=#{url}, data.size=#{data.size}")

      _parse(url, data)
    end

    def redownload?
      @logger.debug("OddsExactaPageParser#redownload?: start")

      base_date = Time.now - 60 * 60 * 24 * 90
      date = Time.local(@start_datetime.year, @start_datetime.month, @start_datetime.day)

      @logger.debug("OddsExactaPageParser#redownload?: base_date=#{base_date}, date=#{date}")

      (base_date < date)
    end

    def valid?
      (@title === "馬単")
    end

    def related_links
      []
    end

    def parse(context)
      # TODO: Parse all result info
      context["odds_exacta"] = {
        @odds_exacta_id => {}
      }
    end

    private

    def _parse(url, data)
      @logger.debug("OddsExactaPageParser#_parse: start")

      @odds_exacta_id = url.match(/^.+?\/odds\/ut\/([0-9]+)\/$/)[1]
      @logger.info("OddsExactaPageParser#_parse: @odds_exacta_id=#{@odds_exacta_id}")

      doc = Nokogiri::HTML.parse(data, nil, "UTF-8")

      doc.xpath("//li[@id='raceNavi2C']").each do |li|
        @logger.debug("OddsExactaPageParser#_parse: li=#{li.inspect}")

        @title = li.children[0].text.strip
        @logger.info("OddsExactaPageParser#_parse: @title=#{@title}")
      end

      doc.xpath("//p[@id='raceTitDay']").each do |p|
        @logger.debug("OddsExactaPageParser#_parse: p")

        date = p.children[0].text.strip.match(/^([0-9]+)年([0-9]+)月([0-9]+)日/) do |date_parts|
          Time.new(date_parts[1].to_i, date_parts[2].to_i, date_parts[3].to_i)
        end

        time = p.children[4].text.strip.match(/^([0-9]+):([0-9]+)発走/) do |time_parts|
          Time.new(1900, 1, 1, time_parts[1].to_i, time_parts[2].to_i, 0)
        end

        if (not date.nil?) && (not time.nil?)
          @start_datetime = Time.new(date.year, date.month, date.day, time.hour, time.min, 0)
          @logger.info("OddsExactaPageParser#_parse: @start_datetime=#{@start_datetime}")
        end
      end
    end
  end
end
