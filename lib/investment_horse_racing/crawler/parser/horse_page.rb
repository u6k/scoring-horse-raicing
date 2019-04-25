require "nokogiri"
require "crawline"

module InvestmentHorseRacing::Crawler::Parser
  class HorsePageParser < Crawline::BaseParser
    def initialize(url, data)
      @logger = InvestmentHorseRacing::Crawler::AppLogger.get_logger
      @logger.debug("HorsePageParser#initialize: start: url=#{url}, data.size=#{data.size}")

      @data = data

      _parse(url, data)
    end

    def redownload?
      @logger.debug("HorsePageParser#redownload?: start: downloaded_timestamp=#{@data["downloaded_timestamp"]}")

      (Time.now.utc - @data["downloaded_timestamp"]) > (30 * 24 * 60 * 60)
    end

    def valid?
      ((not @horse_id.nil?) &&
        (not @gender.nil?) &&
        (not @name.nil?) &&
        (not @date_of_birth.nil?) &&
        (not @coat_color.nil?) &&
        (not @trainer_id.nil?) &&
        (not @owner.nil?) &&
        (not @breeder.nil?) &&
        (not @breeding_center.nil?))
    end

    def related_links
      @related_links
    end

    def parse(context)
      # TODO: Parse all horse info
      context["horses"] = {
        @horse_id => {
          "horse_id" => @horse_id,
          "gender" => @gender,
          "name" => @name,
          "date_of_birth" => @date_of_birth,
          "coat_color" => @coat_color,
          "trainer_id" => @trainer_id,
          "owner" => @owner,
          "breeder" => @breeder,
          "breeding_center" => @breeding_center
        }
      }
    end

    private

    def _parse(url, data)
      @logger.debug("HorsePageParser#_parse: start")

      @horse_id = url.match(/^.+?\/directory\/horse\/([0-9]+)\/$/)[1]
      @logger.debug("HorsePageParser#_parse: @horse_id=#{@horse_id}")

      doc = Nokogiri::HTML.parse(data["response_body"], nil, "UTF-8")

      doc.xpath("//div[@id='dirTitName']").each do |div|
        div.xpath("p[@class='fntSS']").each do |p|
          @gender = p.text.split("|")[0].strip
          @logger.debug("HorsePageParser#_parse: @gender=#{@gender}")
        end

        div.xpath("h1[@class='fntB']").each do |h1|
          @name = h1.text.strip
          @logger.debug("HorsePageParser#_parse: @name=#{@name}")
        end

        div.xpath("ul/li").each do |li|
          @logger.debug("HorsePageParser#_parse: li=#{li.inspect}")

          case li.children[0].text
          when /^生年月日/
            @date_of_birth = li.children[1].text.strip.match(/([0-9]{4})年([0-9]{1,2})月([0-9]{1,2})日/) do |date_parts|
              Time.local(date_parts[1].to_i, date_parts[2].to_i, date_parts[3].to_i)
            end
            @logger.debug("HorsePageParser#_parse: @date_of_birth=#{@date_of_birth}")
          when /^毛色/
            @coat_color = li.children[1].text.strip
            @logger.debug("HorsePageParser#_parse: @coat_color=#{@coat_color}")
          when /^調教師/
            @trainer_id = li.children[1]["href"].match(/^\/directory\/trainer\/([0-9]+)\//) do |path|
              path[1]
            end
            @logger.debug("HorsePageParser#_parse: @trainer_id=#{@trainer_id}")

            @related_links = [URI.join(url, li.children[1]["href"]).to_s]
            @logger.debug("HorsePageParser#_parse: @related_links=#{@related_links}")
          when /^馬主/
            @owner = li.children[1].text.strip
            @logger.debug("HorsePageParser#_parse: @owner=#{@owner}")
          when /^生産者/
            @breeder = li.children[1].text.strip
            @logger.debug("HorsePageParser#_parse: @breeder=#{@breeder}")
          when /^産地/
            @breeding_center = li.children[1].text.strip
            @logger.debug("HorsePageParser#_parse: @breeding_center=#{@breeding_center}")
          end
        end
      end
    end
  end
end
