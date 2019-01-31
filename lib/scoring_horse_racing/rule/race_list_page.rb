# require "nokogiri"

# module ScoringHorseRacing::Rule
#   class RaceListPage

#     attr_reader :race_id, :date, :course_name, :result_pages

#     def initialize(race_id, content, downloader, repo)
#       @race_id = race_id
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

#     def exists?
#       @repo.exists_s3_object?(_build_s3_path)
#     end

#     def valid?
#       ((not @date.nil?) \
#       && (not @course_name.nil?) \
#       && (not @result_pages.nil?) \
#       && (not @content.nil?))
#     end

#     def save!
#       if not valid?
#         raise "Invalid"
#       end

#       @repo.put_s3_object(_build_s3_path, @content)
#     end

#     def same?(obj)
#       if not obj.instance_of?(RaceListPage)
#         return false
#       end

#       if self.race_id != obj.race_id \
#         || self.date != obj.date \
#         || self.course_name != obj.course_name \
#         || self.result_pages.nil? != obj.result_pages.nil?
#         return false
#       end

#       if (not self.result_pages.nil?) && (not obj.result_pages.nil?)
#         self.result_pages.each do |result_page_self|
#           result_page_obj = obj.result_pages.find { |r| r.result_id == result_page_self.result_id }

#           return false if not result_page_self.same?(result_page_obj)
#         end
#       end

#       true
#     end

#     private

#     def _parse
#       if @content.nil?
#         return nil
#       end

#       doc = Nokogiri::HTML.parse(@content, nil, "UTF-8")

#       h4 = doc.at_xpath("//div[@id='cornerTit']/h4")
#       if not h4.nil?
#         h4.text.match(/^([0-9]+)年([0-9]+)月([0-9]+)日/) do |date_parts|
#           @date = Time.new(date_parts[1].to_i, date_parts[2].to_i, date_parts[3].to_i)
#         end
#       end

#       a = doc.at_xpath("//li[@id='racePlaceNaviC']/a")
#       if not a.nil?
#         @course_name = a.text
#       end

#       @result_pages = doc.xpath("//table[@class='scheLs']/tbody/tr").map do |tr|
#         a = tr.at_xpath("td[@class='wsLB']/a")
#         if not a.nil?
#           a.attribute("href").value.match(/^\/race\/result\/([0-9]+)\/$/) do |path|
#             ResultPage.new(path[1], nil, @downloader, @repo)
#           end
#         end
#       end

#       @result_pages.compact!
#       if @result_pages.empty?
#         @result_pages = nil
#       end
#     end

#     def _build_url
#       "https://keiba.yahoo.co.jp/race/list/#{@race_id}/"
#     end

#     def _build_s3_path
#       "race_list.#{@race_id}.html"
#     end

#   end
# end
