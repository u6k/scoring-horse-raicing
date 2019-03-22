require "nokogiri"
require "crawline"

module ScoringHorseRacing::Parser
  class RaceListPageParser < Crawline::BaseParser
    def initialize(url, data)
      @logger = ScoringHorseRacing::AppLogger.get_logger
      @logger.debug("RaceListPageParser#initialize: start: url=#{url}, data.size=#{data.size}")

      @data = data

      _parse(url, data)
    end

    def redownload?
      @logger.debug("RaceListPageParser#redownload?: start")

      return false if (Time.now.utc - @data["downloaded_timestamp"]) < (24 * 60 * 60)

      (Time.now - @date) < (90 * 24 * 60 * 60)
    end

    def valid?
      ((not @related_links.empty?) &&
        (not @race_id.nil?) &&
        (not @date.nil?) &&
        (not @course_name.nil?))
    end

    def related_links
      @related_links
    end

    def parse(context)
      context["races"] = {
        @race_id => {
          "race_id" => @race_id,
          "date" => @date,
          "course_name" => @course_name
        }
      }
    end

    private

    def _parse(url, data)
      @logger.debug("RaceListPageParser#_parse: start")

      @race_id = url.match(/^.+?\/race\/list\/([0-9]+)\/$/)[1]
      @logger.debug("RaceListPageParser#_parse: @race_id=#{@race_id}")

      doc = Nokogiri::HTML.parse(data["response_body"], nil, "UTF-8")

      h4 = doc.at_xpath("//div[@id='cornerTit']/h4")
      if not h4.nil?
        @logger.debug("RaceListPageParser#_parse: h4=#{h4.inspect}")

        h4.text.match(/^([0-9]+)年([0-9]+)月([0-9]+)日/) do |date_parts|
          @logger.debug("RaceListPageParser#_parse: date_parts=#{date_parts.inspect}")

          @date = Time.local(date_parts[1].to_i, date_parts[2].to_i, date_parts[3].to_i)
          @logger.debug("RaceListPageParser#_parse: @date=#{@date}")
        end
      end

      a = doc.at_xpath("//li[@id='racePlaceNaviC']/a")
      if not a.nil?
        @logger.debug("RaceListPageParser#_parse: a=#{a.inspect}")

        @course_name = a.text
        @logger.debug("RaceListPageParser#_parse: @course_name=#{@course_name}")
      end

      @related_links = doc.xpath("//table[@class='scheLs']/tbody/tr").map do |tr|
        @logger.debug("RaceListPageParser#_parse: tr")

        a = tr.at_xpath("td[@class='wsLB']/a")
        if not a.nil?
          @logger.debug("RaceListPageParser#_parse: a=#{a.inspect}")

          a.attribute("href").value.match(/^\/race\/result\/([0-9]+)\/$/) do |path|
            @logger.debug("RaceListPageParser#_parse: path=#{path.inspect}")

            URI.join(url, path[0]).to_s
          end
        end
      end

      @related_links.compact!

      @related_links.each do |related_link|
        @logger.debug("RaceListPageParser#_parse: related_link=#{related_link}")
      end
    end
  end
end
