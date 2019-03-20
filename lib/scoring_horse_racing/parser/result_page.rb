require "nokogiri"
require "crawline"

module ScoringHorseRacing::Parser
  class ResultPageParser < Crawline::BaseParser
    def initialize(url, data)
      @logger = ScoringHorseRacing::AppLogger.get_logger
      @logger.debug("ResultPageParser#initialize: start: url=#{url}, data.size=#{data.size}")

      _parse(url, data)
    end

    def redownload?
      @logger.debug("ResultPageParser#redownload?: start")

      base_date = Time.now - 60 * 60 * 24 * 90
      date = Time.local(@start_datetime.year, @start_datetime.month, @start_datetime.day)

      @logger.debug("ResultPageParser#redownload?: base_date=#{base_date}, date=#{date}")

      (base_date < date)
    end

    def valid?
      ((not @related_links.empty?) &&
        (not @result_id.nil?) &&
        (not @race_number.nil?) &&
        (not @start_datetime.nil?) &&
        (not @race_name.nil?))
    end

    def related_links
      @related_links
    end

    def parse(context)
      # TODO: Parse all result info
      context["results"] = {
        @result_id => {
          "result_id" => @result_id,
          "race_number" => @race_number,
          "start_datetime" => @start_datetime,
          "race_name" => @race_name
        }
      }
    end

    private

    def _parse(url, data)
      @logger.debug("ResultPageParser#_parse: start")

      @result_id = url.match(/^.+?\/result\/([0-9]+)\/$/)[1]
      @logger.debug("ResultPageParser#_parse: @result_id=#{@result_id}")

      doc = Nokogiri::HTML.parse(data["response_body"], nil, "UTF-8")

      doc.xpath("//td[@id='raceNo']").each do |td|
        @logger.debug("ResultPageParser#_parse: td")

        td.text.match(/^([0-9]+)R$/) do |race_number|
          @logger.debug("ResultPageParser#_parse: race_number=#{race_number.inspect}")

          @race_number = race_number[1].to_i
          @logger.debug("ResultPageParser#_parse: @race_number=#{@race_number}")
        end
      end

      doc.xpath("//p[@id='raceTitDay']").each do |p|
        @logger.debug("ResultPageParser#_parse: p")

        date = p.children[0].text.strip.match(/^([0-9]+)年([0-9]+)月([0-9]+)日/) do |date_parts|
          @logger.debug("ResultPageParser#_parse: date_parts=#{date_parts.inspect}")
          Time.new(date_parts[1].to_i, date_parts[2].to_i, date_parts[3].to_i)
        end

        time = p.children[4].text.strip.match(/^([0-9]+):([0-9]+)発走/) do |time_parts|
          @logger.debug("ResultPageParser#_parse: time_parts=#{time_parts.inspect}")
          Time.new(1900, 1, 1, time_parts[1].to_i, time_parts[2].to_i, 0)
        end

        if (not date.nil?) && (not time.nil?)
          @start_datetime = Time.new(date.year, date.month, date.day, time.hour, time.min, 0)
          @logger.debug("ResultPageParser#_parse: @start_datetime=#{@start_datetime}")
        end
      end

      doc.xpath("//h1[@class='fntB']").map do |h1|
        @logger.debug("ResultPageParser#_parse: h1=#{h1.inspect}")

        @race_name = h1.text.strip
        @logger.debug("ResultPageParser#_parse: @race_name=#{@race_name}")
      end

      @related_links = []

      doc.xpath("//div[@id='raceNavi']/ul/li/a").each do |a|
        @logger.debug("ResultPageParser#_parse: a=#{a.inspect}")

        if a.text == "出馬表"
          a["href"].match(/^\/race\/denma\/[0-9]+\/$/) do |path|
            @logger.debug("ResultPageParser#_parse: path=#{path.inspect}")
            @related_links << URI.join(url, path[0]).to_s
          end
        elsif a.text == "オッズ"
          a["href"].match(/^\/odds\/tfw\/[0-9]+\/$/) do |path|
            @logger.debug("ResultPageParser#_parse: path=#{path.inspect}")
            @related_links << URI.join(url, path[0]).to_s
          end
        end
      end

      doc.xpath("//a[starts-with(@href, '/directory/horse/')]").each do |a|
        @logger.debug("ResultPageParser#_parse: a=#{a.inspect}")
        @related_links << URI.join(url, a["href"]).to_s
      end

      doc.xpath("//a[starts-with(@href, '/directory/jocky/')]").each do |a|
        @logger.debug("ResultPageParser#_parse: a=#{a.inspect}")
        @related_links << URI.join(url, a["href"]).to_s
      end

      doc.xpath("//a[starts-with(@href, '/directory/trainer/')]").each do |a|
        @logger.debug("ResultPageParser#_parse: a=#{a.inspect}")
        @related_links << URI.join(url, a["href"]).to_s
      end

      @related_links.each do |related_link|
        @logger.debug("ResultPageParser#_parse: related_link=#{related_link}")
      end
    end
  end
end
