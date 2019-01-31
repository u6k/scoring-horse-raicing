# require "nokogiri"

# module ScoringHorseRacing::Rule
#   class OddsQuinellaPlacePage

#     attr_reader :odds_id, :quinella_place_results

#     def initialize(odds_id, content, downloader, repo)
#       @odds_id = odds_id
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
#         && (not @quinella_place_results.nil?))
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
#       if not obj.instance_of?(OddsQuinellaPlacePage)
#         return false
#       end

#       if @odds_id != obj.odds_id \
#         || @quinella_place_results.nil? != obj.quinella_place_results.nil?
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

#       doc.xpath("//li[@id='raceNavi2C']/a").each do |a|
#         @quinella_place_results = a.text
#       end
#     end

#     def _build_url
#       "https://keiba.yahoo.co.jp/odds/ur/#{@odds_id}/"
#     end

#     def _build_s3_path
#       "odds_quinella_place.#{@odds_id}.html"
#     end

#   end
# end
