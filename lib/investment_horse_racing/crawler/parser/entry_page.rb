require "nokogiri"
require "crawline"

module InvestmentHorseRacing::Crawler::Parser
  class EntryPageParser < Crawline::BaseParser
    def initialize(url, data)
      @logger = InvestmentHorseRacing::Crawler::AppLogger.get_logger
      @logger.debug("EntryPageParser#initialize: start: url=#{url}, data.size=#{data.size})")

      @data = data

      _parse(url, data)
    end

    def redownload?
      @logger.debug("EntryPageParser#redownload?: start")

      return false if (Time.now.utc - @data["downloaded_timestamp"]) < (24 * 60 * 60)

      start_date = Time.local(@start_datetime.year, @start_datetime.month, @start_datetime.day)

      (Time.now - start_date) < (90 * 24 * 60 * 60)
    end

    def valid?
      ((not @related_links.empty?) &&
        (not @entry_id.nil?) &&
        (not @race_number.nil?) &&
        (not @start_datetime.nil?) &&
        (not @race_name.nil?))
    end

    def related_links
      @related_links
    end

    def parse(context)
      # TODO: Parse all result info
      context["entries"] = {
        @entry_id => {
          "entry_id" => @entry_id,
          "race_number" => @race_number,
          "start_datetime" => @start_datetime,
          "race_name" => @race_name
        }
      }
    end

    private

    def _parse(url, data)
      @logger.debug("EntryPageParser#_parse: start")

      @entry_id = url.match(/^.+?\/race\/denma\/([0-9]+)\/$/)[1]
      @logger.debug("EntryPageParser#_parse: @entry_id=#{@entry_id}")

      doc = Nokogiri::HTML.parse(data["response_body"], nil, "UTF-8")

      doc.xpath("//td[@id='raceNo']").each do |td|
        @logger.debug("EntryPageParser#_parse: td")

        td.text.match(/^([0-9]+)R$/) do |race_number|
          @race_number = race_number[1].to_i
          @logger.debug("EntryPageParser#_parse: @race_number=#{@race_number}")
        end
      end

      doc.xpath("//p[@id='raceTitDay']").each do |p|
        @logger.debug("EntryPageParser#_parse: p")

        date = p.children[0].text.strip.match(/^([0-9]+)年([0-9]+)月([0-9]+)日/) do |date_parts|
          Time.new(date_parts[1].to_i, date_parts[2].to_i, date_parts[3].to_i)
        end

        time = p.children[4].text.strip.match(/^([0-9]+):([0-9]+)発走/) do |time_parts|
          Time.new(1900, 1, 1, time_parts[1].to_i, time_parts[2].to_i, 0)
        end

        if (not date.nil?) && (not time.nil?)
          @start_datetime = Time.new(date.year, date.month, date.day, time.hour, time.min, 0)
          @logger.debug("EntryPageParser#_parse: @start_datetime=#{@start_datetime}")
        end
      end

      doc.xpath("//h1[@class='fntB']").map do |h1|
        @logger.debug("EntryPageParser#_parse: h1")

        @race_name = h1.text.strip
        @logger.debug("EntryPageParser#_parse: @race_name=#{@race_name}")
      end

      @related_links = []

      doc.xpath("//a[starts-with(@href, '/directory/horse/')]").each do |a|
        @logger.debug("EntryPageParser#_parse: a=#{a.inspect}")
        @related_links << URI.join(url, a["href"]).to_s
      end

      doc.xpath("//a[starts-with(@href, '/directory/jocky/')]").each do |a|
        @logger.debug("EntryPageParser#_parse: a=#{a.inspect}")
        @related_links << URI.join(url, a["href"]).to_s
      end

      doc.xpath("//a[starts-with(@href, '/directory/trainer/')]").each do |a|
        @logger.debug("EntryPageParser#_parse: a=#{a.inspect}")
        @related_links << URI.join(url, a["href"]).to_s
      end

      @related_links.each do |related_link|
        @logger.debug("EntryPageParser#_parse: related_link=#{related_link}")
      end
    end
  end
end
