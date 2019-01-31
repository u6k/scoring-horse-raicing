# require "nokogiri"

# module ScoringHorseRacing::Rule
#   class OddsTrifectaPage

#     attr_reader :odds_id, :horse_number, :trifecta_results, :odds_trifecta_pages

#     def initialize(odds_id, horse_number, content, downloader, repo)
#       @odds_id = odds_id
#       if horse_number.nil?
#         @horse_number = 1
#       else
#         @horse_number = horse_number
#       end
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
#       ((not @odds_id.nil?) \
#         && (not @horse_number.nil?) \
#         && (not @trifecta_results.nil?))
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
#       if not obj.instance_of?(OddsTrifectaPage)
#         return false
#       end

#       if @odds_id != obj.odds_id \
#         || @horse_number != obj.horse_number \
#         || @trifecta_results.nil? != obj.trifecta_results.nil? \
#         || @odds_trifecta_pages.nil? != obj.odds_trifecta_pages.nil?
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

#       doc.xpath("//form[@id='odds3TN']/select[@name='umaBan']/option[@value='#{@horse_number}']").each do |option|
#         if option["selected"] != "selected"
#           return nil
#         end
#       end

#       doc.xpath("//li[@id='raceNavi2C']/a").each do |a|
#         @trifecta_results = a.text
#       end

#       @odds_trifecta_pages = {}
#       doc.xpath("//form[@id='odds3TN']/select[@name='umaBan']/option").each do |option|
#         @odds_trifecta_pages[option["value"].to_i] = OddsTrifectaPage.new(@odds_id, option["value"].to_i, nil, @downloader, @repo)
#       end

#       @odds_trifecta_pages = nil if @odds_trifecta_pages.empty?
#     end

#     def _build_url
#       "https://keiba.yahoo.co.jp/odds/st/#{@odds_id}/?umaBan=#{@horse_number}&position=1"
#     end

#     def _build_s3_path
#       "odds_trifecta.#{@odds_id}.#{@horse_number}.html"
#     end

#   end
# end