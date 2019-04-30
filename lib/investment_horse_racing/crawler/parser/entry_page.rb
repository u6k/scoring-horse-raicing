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

      start_date = Time.local(@race_meta.start_datetime.year, @race_meta.start_datetime.month, @race_meta.start_datetime.day)

      (Time.now - start_date) < (90 * 24 * 60 * 60)
    end

    def valid?
      ((not @related_links.empty?) &&
        (not @entries.empty?))
    end

    def related_links
      @related_links
    end

    def parse(context)
      @logger.debug("EntryPageParser#parse: start")

      @race_meta.race_entries.destroy_all

      @entries.each { |e| e.save! }
    end

    private

    def _parse(url, data)
      @logger.debug("EntryPageParser#_parse: start")

      race_id = url.match(/^.+?\/race\/denma\/([0-9]+)\/$/)[1]
      @race_meta = InvestmentHorseRacing::Crawler::Model::RaceMeta.find_by(race_id: race_id)
      raise "RaceMeta(race_id: #{race_id}) not found." if @race_meta.nil?
      @logger.debug("EntryPageParser#_parse: parent race_meta.id=#{@race_meta.id}")

      doc = Nokogiri::HTML.parse(data["response_body"], nil, "UTF-8")

      @entries = doc.xpath("//table[contains(@class,'denmaLs')]/tr[position()>1]").map do |tr|
        @logger.debug("EntryPageParser#_parse: tr=#{tr}")

        entry = InvestmentHorseRacing::Crawler::Model::RaceEntry.new(
          race_meta: @race_meta,
          bracket_number: tr.at_xpath("td[1]").text.strip,
          horse_number: tr.at_xpath("td[2]").text.strip,
          horse_id: tr.at_xpath("td[3]/a[1]")["href"][/\/directory\/horse\/(\d+)\//, 1],
          horse_name: tr.at_xpath("td[3]/a[1]").text.strip,
          gender: tr.at_xpath("td[3]/span/text()").text[/^(.+?)(\d+)\/(.+)$/, 1],
          age: tr.at_xpath("td[3]/span/text()").text[/^(.+?)(\d+)\/(.+)$/, 2].to_i,
          coat_color: tr.at_xpath("td[3]/span/text()").text[/^(.+?)(\d+)\/(.+)$/, 3].strip,
          trainer_id: tr.at_xpath("td[3]/span/a")["href"][/\/directory\/trainer\/(\d+)\//, 1],
          trainer_name: tr.at_xpath("td[3]/span/a").text.strip,
          horse_weight: tr.at_xpath("td[4]/text()").text.to_i,
          jockey_id: tr.at_xpath("td[5]/a")["href"][/\/directory\/jocky\/(\d+)\//, 1],
          jockey_name: tr.at_xpath("td[5]/a").text.strip,
          jockey_weight: tr.at_xpath("td[5]/text()").text.strip.to_f,
          father_horse_name: tr.at_xpath("td[6]/text()[1]").text.strip,
          mother_horse_name: tr.at_xpath("td[6]/text()[2]").text.strip)
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

module InvestmentHorseRacing::Crawler::Model
  class RaceEntry < ActiveRecord::Base
    belongs_to :race_meta

    validates :race_meta, presence: true
  end
end
