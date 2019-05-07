require "nokogiri"
require "crawline"
require "active_record"
require "activerecord-import"

module InvestmentHorseRacing::Crawler::Parser
  class ResultPageParser < Crawline::BaseParser
    def initialize(url, data)
      @logger = InvestmentHorseRacing::Crawler::AppLogger.get_logger
      @logger.debug("ResultPageParser#initialize: start: url=#{url}, data.size=#{data.size}")

      @data = data

      _parse(url, data)
    end

    def redownload?
      @logger.debug("ResultPageParser#redownload?: start")

      if not @race_meta.start_datetime.nil?
        (Time.now - @race_meta.start_datetime) < (30 * 24 * 60 * 60)
      else
        true
      end
    end

    def related_links
      @related_links
    end

    def parse(context)
      @logger.debug("ResultPageParser#parse: start")

      ActiveRecord::Base.transaction do
        InvestmentHorseRacing::Crawler::Model::RaceMeta.where(race_id: @race_meta.race_id).destroy_all
        @logger.debug("ResultPageParser#parse: RaceMeta(race_id: #{@race_meta.race_id}) destroy all")

        @race_meta.save!
        @logger.debug("ResultPageParser#parse: RaceMeta(id: #{@race_meta.id}) saved")

        InvestmentHorseRacing::Crawler::Model::RaceRefund.import(@refunds)
        @logger.debug("ResultPageParser#parse: RaceRefunds(count: #{@refunds.count}) saved")

        InvestmentHorseRacing::Crawler::Model::RaceScore.import(@scores)
        @logger.debug("ResultPageParser#parse: RaceScores(count: #{@scores.count}) saved")
      end
    end

    private

    def _parse(url, data)
      @logger.debug("ResultPageParser#_parse: start")

      @race_meta = InvestmentHorseRacing::Crawler::Model::RaceMeta.new
      @race_meta.race_id = url.match(/^.+?\/result\/([0-9]+)\/$/)[1]
      @logger.debug("ResultPageParser#_parse: race_id=#{@race_meta.race_id}")

      doc = Nokogiri::HTML.parse(data["response_body"], nil, "UTF-8")

      doc.xpath("//td[@id='raceNo']").each do |td|
        @logger.debug("ResultPageParser#_parse: td")

        td.text.match(/^([0-9]+)R$/) do |race_number|
          @logger.debug("ResultPageParser#_parse: race_number=#{race_number.inspect}")

          @race_meta.race_number = race_number[1].to_i
        end
      end

      doc.xpath("//li[@id='racePlaceNaviC']/a").each do |a|
        @logger.debug("ResultPageParser#_parse: a")

        @race_meta.course_name = a.text.strip
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
          @race_meta.start_datetime = Time.new(date.year, date.month, date.day, time.hour, time.min, 0)
          @logger.debug("ResultPageParser#_parse: start_datetime=#{@race_meta.start_datetime}")
        end
      end

      doc.xpath("//h1[@class='fntB']").map do |h1|
        @logger.debug("ResultPageParser#_parse: h1=#{h1.inspect}")

        @race_meta.race_name = h1.text.strip
      end

      doc.xpath("//p[@id='raceTitMeta']").each do |p|
        @logger.debug("ResultPageParser#_parse: p.raceTitMeta=#{p.inspect}")
        raceMetas = p.text.split("|")
        @race_meta.course_length = raceMetas[0].strip
        @race_meta.weather = p.at_xpath("img[1]")["alt"].strip
        @race_meta.course_condition = p.at_xpath("img[2]")["alt"].strip
        @race_meta.race_class = raceMetas[3].strip
        @race_meta.prize_class = raceMetas[4].strip
      end

      @refunds = []

      doc.xpath("//table[contains(@class,'resultYen')]/tr").each do |tr|
        @logger.debug("ResultPageParser#_parse: resultYen=#{tr}")

        refund = InvestmentHorseRacing::Crawler::Model::RaceRefund.new(race_meta: @race_meta)
        refund.refund_type = case tr.at_xpath("th")
                             when nil then @refunds[-1].refund_type
                      else case tr.at_xpath("th").text.strip
                        when "単勝" then "win"
                        when "複勝" then "place"
                        when "枠連" then "bracket_quinella"
                        when "馬連" then "quinella"
                        when "ワイド" then "quinella_place"
                        when "馬単" then "exacta"
                        when "3連複" then "trio"
                        when "3連単" then "tierce"
                        when nil then @refunds[-1].refund_type
                        else raise "Unknown refund type"
                        end
                      end
        
        refund.horse_numbers = tr.at_xpath("td[contains(@class,'resultNo')]").text.strip.gsub(/－/, "-")

        refund.money = tr.at_xpath("td[2]").text.gsub(/,/,"").gsub(/円/,"").strip.to_i

        @refunds << refund if refund.money != 0
      end

      @scores = doc.xpath("//table[@id='raceScore']/tbody/tr").map do |tr|
        @logger.debug("ResultPageParser#_parse: raceScore=#{tr}")

        score = InvestmentHorseRacing::Crawler::Model::RaceScore.new(
          race_meta: @race_meta,
          rank: (tr.at_xpath("td[1]").text.strip =~ /\d+/ ? tr.at_xpath("td[1]").text.strip.to_i : nil),
          bracket_number: tr.at_xpath("td[2]").text.strip.to_i,
          horse_number: tr.at_xpath("td[3]").text.strip.to_i
        )

        if tr.at_xpath("td[5]/text()").text.strip.empty?
          score.time = nil
        else
          parts = tr.at_xpath("td[5]/text()").text.strip.split(".")
          score.time = parts[0].to_i * 60 + parts[1].to_i + "0.#{parts[2]}".to_f
        end

        @logger.debug("score=#{score}")

        score
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

      @related_links.each do |related_link|
        @logger.debug("ResultPageParser#_parse: related_link=#{related_link}")
      end
    end
  end
end

module InvestmentHorseRacing::Crawler::Model
  class RaceMeta < ActiveRecord::Base
    has_many :race_refunds, dependent: :destroy
    has_many :race_scores, dependent: :destroy
    has_many :race_entries, dependent: :destroy
  end

  class RaceRefund < ActiveRecord::Base
    belongs_to :race_meta

    validates :race_meta, presence: true
  end

  class RaceScore < ActiveRecord::Base
    belongs_to :race_meta

    validates :race_meta, presence: true
  end
end
