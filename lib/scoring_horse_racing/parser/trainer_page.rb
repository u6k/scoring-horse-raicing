require "nokogiri"
require "crawline"

module ScoringHorseRacing::Parser
  class TrainerPageParser < Crawline::BaseParser
    def initialize(url, data)
      @logger = ScoringHorseRacing::AppLogger.get_logger
      @logger.debug("TrainerPageParser#initialize: start: url=#{url}, data.size=#{data.size}")

      _parse(url, data)
    end

    def redownload?
      @logger.debug("TrainerPageParser#redownload?: start")

      # TODO: Redownload if one month or more when last download
      false
    end

    def valid?
      ((not @trainer_id.nil?) &&
        (not @name.nil?) &&
        (not @name_kana.nil?) &&
        (not @date_of_birth.nil?) &&
        (not @affiliation.nil?))
    end

    def related_links
      []
    end

    def parse(context)
      # TODO: Parse all trainer info
      context["trainers"] = {
        @trainer_id => {
          "trainer_id" => @trainer_id,
          "name" => @name,
          "name_kana" => @name_kana,
          "date_of_birth" => @date_of_birth,
          "affiliation" => @affiliation
        }
      }
    end

    private

    def _parse(url, data)
      @logger.debug("TrainerPageParser#_parse: start")

      @trainer_id = url.match(/^.+?\/directory\/trainer\/([0-9]+)\/$/)[1]
      @logger.debug("TrainerPageParser#_parse: @trainer_id=#{@trainer_id}")

      doc = Nokogiri::HTML.parse(data["response_body"], nil, "UTF-8")

      doc.xpath("//div[@id='dirTitName']").each do |div|
        div.xpath("p[@class='fntSS']").each do |p|
          @name_kana = p.text.split("|")[0].strip
          @logger.debug("TrainerPageParser#_parse: @name_kana=#{@name_kana}")
        end

        div.xpath("h1[@class='fntB']").each do |h1|
          @name = h1.text.strip
          @logger.debug("TrainerPageParser#_parse: @name=#{@name}")
        end

        div.xpath("ul/li").each do |li|
          @logger.debug("TrainerPageParser#_parse: li=#{li.inspect}")

          if li.children.size >= 2
            case li.children[0].text
            when /^生年月日/
              @date_of_birth = li.children[1].text.strip.match(/([0-9]{4})年([0-9]{1,2})月([0-9]{1,2})日/) do |date_parts|
                Time.local(date_parts[1].to_i, date_parts[2].to_i, date_parts[3].to_i)
              end
              @logger.debug("TrainerPageParser#_parse: @date_of_birth=#{@date_of_birth}")
            when /^所属/
              @affiliation = li.children[1].text.strip
              @logger.debug("TrainerPageParser#_parse: @affiliation=#{@affiliation}")
            end
          end
        end
      end
    end
  end
end
