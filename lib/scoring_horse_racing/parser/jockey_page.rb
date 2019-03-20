require "nokogiri"
require "crawline"

module ScoringHorseRacing::Parser
  class JockeyPageParser < Crawline::BaseParser
    def initialize(url, data)
      @logger = ScoringHorseRacing::AppLogger.get_logger
      @logger.debug("JockeyPageParser#initialize: start: url=#{url}, data.size=#{data.size}")

      _parse(url, data)
    end

    def redownload?
      @logger.debug("JockeyPageParser#redownload?")

      # TODO: Redownload if one month or more when last download
      false
    end

    def valid?
      ((not @jockey_id.nil?) &&
        (not @name.nil?) &&
        (not @name_kana.nil?) &&
        (not @date_of_birth.nil?) &&
        (not @affiliation.nil?))
    end

    def related_links
      []
    end

    def parse(context)
      # TODO: Parse all jockey info
      context["jockeys"] = {
        @jockey_id => {
          "jockey_id" => @jockey_id,
          "name" => @name,
          "name_kana" => @name_kana,
          "date_of_birth" => @date_of_birth,
          "affiliation" => @affiliation
        }
      }
    end

    private

    def _parse(url, data)
      @logger.debug("JockeyPageParser#_parse: start")

      @jockey_id = url.match(/^.+?\/directory\/jocky\/([0-9]+)\/$/)[1]
      @logger.debug("JockeyPageParser#_parse: @jockey_id=#{@jockey_id}")

      doc = Nokogiri::HTML.parse(data["response_body"], nil, "UTF-8")

      doc.xpath("//div[@id='dirTitName']").each do |div|
        div.xpath("p[@class='fntSS']").each do |p|
          @name_kana = p.text.split("|")[0].strip
          @logger.debug("JockeyPageParser#_parse: @name_kana=#{@name_kana}")
        end

        div.xpath("h1[@class='fntB']").each do |h1|
          @name = h1.text.strip
          @logger.debug("JockeyPageParser#_parse: @name=#{@name}")
        end

        div.xpath("ul/li").each do |li|
          case li.children[0].text
          when /^生年月日/
            @date_of_birth = li.children[1].text.strip.match(/([0-9]{4})年([0-9]{1,2})月([0-9]{1,2})日/) do |date_parts|
              Time.local(date_parts[1].to_i, date_parts[2].to_i, date_parts[3].to_i)
            end
            @logger.debug("JockeyPageParser#_parse: @date_of_birth=#{@date_of_birth}")
          when /^所属/
            @affiliation = li.children[1].text.strip
            @logger.debug("JockeyPageParser#_parse: @affiliation=#{@affiliation}")
          end
        end
      end
    end
  end
end
