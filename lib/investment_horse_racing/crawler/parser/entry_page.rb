require "nokogiri"
require "crawline"
require "active_record"
require "activerecord-import"

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

      (Time.now - @race_meta.start_datetime) < (30 * 24 * 60 * 60)
    end

    def related_links
    end

    def parse(context)
      @logger.debug("EntryPageParser#parse: start: start_datetime=#{@race_meta.start_datetime}, race_number=#{@race_meta.race_number}")

      ActiveRecord::Base.transaction do
        @race_meta.race_entries.destroy_all
        @logger.debug("EntryPageParser#parse: RaceEntry(race_meta_id: #{@race_meta.id}) destroy all")

        InvestmentHorseRacing::Crawler::Model::RaceEntry.import(@entries)
        @logger.debug("EntryPageParser#parse: RaceEntries(count: #{@entries.count}) saved")
      end
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
          trainer_id: nil,
          trainer_name: nil,
          horse_weight: tr.at_xpath("td[4]/text()").text.to_i,
          jockey_id: nil,
          jockey_name: nil,
          jockey_weight: tr.at_xpath("td[5]/text()").text.strip.to_f,
          father_horse_name: tr.at_xpath("td[6]/text()[1]").text.strip,
          mother_horse_name: tr.at_xpath("td[6]/text()[2]").text.strip)

        tr.xpath("td[3]/span/a").each do |a|
          entry["trainer_id"] = a["href"][/\/directory\/trainer\/(\d+)\//, 1]
          entry["trainer_name"] = a.text.strip
        end

        tr.xpath("td[5]/a").each do |a|
          entry["jockey_id"] = a["href"][/\/directory\/jocky\/(\d+)\//, 1]
          entry["jockey_name"] = a.text.strip
        end

        if tr.at_xpath("td[3]/span/text()").text.match(/^(.+?)(\d+)\/(.+)$/)
          entry[:gender] = tr.at_xpath("td[3]/span/text()").text[/^(.+?)(\d+)\/(.+)$/, 1]
          entry[:age] = tr.at_xpath("td[3]/span/text()").text[/^(.+?)(\d+)\/(.+)$/, 2].to_i
          entry[:coat_color] = tr.at_xpath("td[3]/span/text()").text[/^(.+?)(\d+)\/(.+)$/, 3].strip
        else
          entry[:gender] = nil
          entry[:age] = nil
          entry[:coat_color] = nil
        end

        entry
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
