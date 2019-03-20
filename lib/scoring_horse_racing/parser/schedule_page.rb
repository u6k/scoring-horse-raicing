require "nokogiri"
require "crawline"

module ScoringHorseRacing::Parser
  class SchedulePageParser < Crawline::BaseParser
    def initialize(url, data)
      @logger = ScoringHorseRacing::AppLogger.get_logger
      @logger.debug("SchedulePageParser#initialize: start: url=#{url}, data.size=#{data.size}")

      _parse(url, data)
    end

    def redownload?
      @logger.debug("SchedulePageParser#redownload?: start")

      base_date = Time.now - 60 * 60 * 24 * 90

      @logger.debug("SchedulePageParser#redownload?: base_date=#{base_date}, @date=#{@date}")

      (base_date < @date)
    end

    def valid?
      ((not @related_links.empty?) &&
        (not @date.nil?))
    end

    def related_links
      @related_links
    end

    def parse(context)
    end

    private

    def _parse(url, data)
      @logger.debug("SchedulePageParser#_parse: start")

      doc = Nokogiri::HTML.parse(data, nil, "UTF-8")

      h3 = doc.at_xpath("//h3[@class='midashi3rd']")
      if not h3.nil?
        @logger.debug("SchedulePageParser#_parse: h3=#{h3.inspect}")

        h3.text.match(/^([0-9]{4})年([0-9]{1,2})月$/) do |date_parts|
          @logger.debug("SchedulePageParser#_parse: date_part=#{date_parts.inspect}")

          @date = Time.local(date_parts[1].to_i, date_parts[2].to_i, 1)
          @logger.debug("SchedulePageParser#_parse: @date=#{@date}")
        end
      end

      @related_links = doc.xpath("//div[contains(@class, 'scheHeadNaviR')]/a").map do |a|
        @logger.debug("SchedulePageParser#_parse: a=#{a.inspect}")

        a.attribute("href").value.match(/^\/schedule\/list\/\d{4}\/\?month=\d{1,2}/) do |path|
          @logger.debug("SchedulePageParser#_parse: path=#{path.inspect}")

          URI.join(url, path[0]).to_s
        end
      end

      @related_links += doc.xpath("//table[contains(@class, 'scheLs')]/tbody/tr/td[position()=1 and @rowspan='2']/a").map do |a|
        @logger.debug("SchedulePageParser#_parse: a=#{a.inspect}")

        a.attribute("href").value.match(/^\/race\/list\/([0-9]+)\/$/) do |path|
          @logger.debug("SchedulePageParser#_parse: path=#{path.inspect}")

          URI.join(url, path[0]).to_s
        end
      end

      @related_links.each do |related_link|
        @logger.debug("SchedulePageParser#_parse: related_link=#{related_link}")
      end
    end
  end
end
