require "nokogiri"
require "crawline"

module ScoringHorseRacing::Parser
  class SchedulePageParser < Crawline::BaseParser
    def initialize(url, data)
      @logger = ScoringHorseRacing::AppLogger.get_logger
      @logger.debug("SchedulePageParser#initialize: start: url=#{url}, data.size=#{data.size}")

      @url = url
      @data = data

      _parse
    end

    def redownload?
      @logger.debug("SchedulePageParser#redownload?: start: Date.today.prev_month(3)=#{Date.today.prev_month(3)}, @date=#{@date}")

      (Date.today.prev_month(3) < @date)
    end

    def valid?
      ((not @related_links.empty?) && (not @date.nil?))
    end

    def related_links
      @related_links
    end

    def parse(context)
    end

    private

    def _parse
      @logger.debug("SchedulePageParser#_parse: start")

      doc = Nokogiri::HTML.parse(@data, nil, "UTF-8")

      h3 = doc.at_xpath("//h3[@class='midashi3rd']")
      if not h3.nil?
        @logger.debug("SchedulePageParser#_parse: h3=#{h3}")

        h3.text.match(/^([0-9]{4})年([0-9]{1,2})月$/) do |date_part|
          @logger.debug("SchedulePageParser#_parse: date_part=#{date_part.inspect}")

          @date = Date.new(date_part[1].to_i, date_part[2].to_i, 1)
        end
      end

      @related_links = doc.xpath("//table[contains(@class, 'scheLs')]/tbody/tr/td[position()=1 and @rowspan='2']/a").map do |a|
        @logger.debug("SchedulePageParser#_parse: a=#{a}")

        a.attribute("href").value.match(/^\/race\/list\/([0-9]+)\/$/) do |path|
          @logger.debug("SchedulePageParser#_parse: path=#{path}")

          URI.join(@url, path[0]).to_s
        end
      end

      @related_links.compact!
    end
  end
end
