require "nokogiri"
require "crawline"

module ScoringHorseRacing::Parser
  class EntryPageParser < Crawline::BaseParser
    def initialize(url, data)
      @logger = ScoringHorseRacing::AppLogger.get_logger
      @logger.info("EntryPageParser#initialize: start: url=#{url}, data.size=#{data.size})")

      _parse(url, data)
    end

    def redownload?
      @logger.debug("EntryPageParser#redownload?: start")

      base_date = Time.now - 60 * 60 * 24 * 90
      date = Time.local(@start_datetime.year, @start_datetime.month, @start_datetime.day)

      @logger.debug("EntryPageParser#redownload?: base_date=#{base_date}, date=#{date}")

      (base_date < date)
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
      @logger.info("EntryPageParser#_parse: @entry_id=#{@entry_id}")

      doc = Nokogiri::HTML.parse(data, nil, "UTF-8")

      doc.xpath("//td[@id='raceNo']").each do |td|
        @logger.debug("EntryPageParser#_parse: td")

        td.text.match(/^([0-9]+)R$/) do |race_number|
          @race_number = race_number[1].to_i
          @logger.info("EntryPageParser#_parse: @race_number=#{@race_number}")
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
          @logger.info("EntryPageParser#_parse: @start_datetime=#{@start_datetime}")
        end
      end

      doc.xpath("//h1[@class='fntB']").map do |h1|
        @logger.debug("EntryPageParser#_parse: h1")

        @race_name = h1.text.strip
        @logger.info("EntryPageParser#_parse: @race_name=#{@race_name}")
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
        @logger.info("EntryPageParser#_parse: related_link=#{related_link}")
      end
    end
  end
end








# require "nokogiri"

# module ScoringHorseRacing::Rule
#   class EntryPage

#     attr_reader :entry_id, :entries

#     def initialize(entry_id, content, downloader, repo)
#       @entry_id = entry_id
#       @content = content
#       @downloader = downloader
#       @repo = repo

#       _parse
#     end

#     def download_from_web!
#       begin
#         @content = @downloader.download_with_get(_build_url)
#       rescue
#         # TODO: Logging warning
#         @content = nil
#       end

#       _parse
#     end

#     def download_from_s3!
#       @content = @repo.get_s3_object(_build_s3_path)

#       _parse
#     end

#     def valid?
#       ((not @entry_id.nil?) \
#         && (not @entries.nil?))
#     end

#     def exists?
#       @repo.exists_s3_object?(_build_s3_path)
#     end

#     def save!
#       if not valid?
#         raise "Invalid"
#       end

#       @repo.put_s3_object(_build_s3_path, @content)
#     end

#     def same?(obj)
#       if not obj.instance_of?(EntryPage)
#         return false
#       end

#       if @entry_id != obj.entry_id \
#         || @entries.nil? != obj.entries.nil?
#         return false
#       end

#       true
#     end

#     private

#     def _parse
#       if @content.nil?
#         return nil
#       end

#       doc = Nokogiri::HTML.parse(@content, nil, "UTF-8")

#       @entries = doc.xpath("//table[contains(@class, 'denmaLs')]/tr").map do |tr|
#         entry = {}

#         tr.xpath("td[@class='txC']/span[contains(@class, 'wk')]").each do |span|
#           span.text.match(/^([0-9]+)$/) do |bracket_number|
#             entry[:bracket_number] = bracket_number[1].to_i
#           end
#         end

#         tr.xpath("td[@class='txC fntB']/strong").each do |strong|
#           strong.text.match(/^([0-9]+)$/) do |horse_number|
#             entry[:horse_number] = horse_number[1].to_i
#           end
#         end

#         tr.xpath("td[@class='fntN']").each do |td|
#           td.at_xpath("a")["href"].match(/^\/directory\/horse\/([0-9]+)\/$/) do |horse_id|
#             entry[:horse] = HorsePage.new(horse_id[1], nil, @downloader, @repo)
#           end

#           td.at_xpath("span[@class='fntSS']/a")["href"].match(/^\/directory\/trainer\/([0-9]+)\/$/) do |trainer_id|
#             entry[:trainer] = TrainerPage.new(trainer_id[1], nil, @downloader, @repo)
#           end
#         end

#         tr.xpath("td[@class='txC']/a").each do |a|
#           a["href"].match(/^\/directory\/jocky\/([0-9]+)\/$/) do |jockey_id|
#             entry[:jockey] = JockeyPage.new(jockey_id[1], nil, @downloader, @repo)
#           end
#         end

#         if entry[:bracket_number].nil?
#           nil
#         else
#           entry
#         end
#       end

#       @entries.compact!
#       if @entries.empty?
#         @entries = nil
#       end
#     end

#     def _build_url
#       "https://keiba.yahoo.co.jp/race/denma/#{@entry_id}/"
#     end

#     def _build_s3_path
#       "entry.#{@entry_id}.html"
#     end

#   end
# end
