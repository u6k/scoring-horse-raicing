require "nokogiri"

module ScoringHorseRacing::Rule
  class SchedulePage

    attr_reader :date, :race_list_pages

    def initialize(year, month, content = nil, downloader, repo)
      @date = Time.new(year, month, 1)
      @content = content
      @downloader = downloader
      @repo = repo

      _parse
    end

    def download_from_web!
      begin
        @content = @downloader.download_with_get(_build_url)
      rescue
        # TODO: Logging warning
        @content = nil
      end

      _parse
    end

    def download_from_s3!
      @content = @repo.get_s3_object(_build_s3_path)

      _parse
    end

    def exists?
      @repo.exists_s3_object?(_build_s3_path)
    end

    def valid?
      (not @race_list_pages.nil?)
    end

    def save!
      if not valid?
        raise "Invalid"
      end

      @repo.put_s3_object(_build_s3_path, @content)
    end

    def same?(obj)
      if not obj.instance_of?(SchedulePage)
        return false
      end

      if self.date != obj.date \
        || self.race_list_pages.nil? != obj.race_list_pages.nil?
        return false
      end

      if (not self.race_list_pages.nil?) && (not obj.race_list_pages.nil?)
        self.race_list_pages.each do |race_list_page_self|
          race_list_page_obj = obj.race_list_pages.find { |r| r.race_id == race_list_page_self.race_id }

          return false if not race_list_page_self.same?(race_list_page_obj)
        end
      end

      true
    end

    private

    def _parse
      if @content.nil?
        return nil
      end

      doc = Nokogiri::HTML.parse(@content, nil, "UTF-8")

      @race_list_pages = doc.xpath("//table[contains(@class, 'scheLs')]/tbody/tr/td[position()=1 and @rowspan='2']/a").map do |a|
        a.attribute("href").value.match(/^\/race\/list\/([0-9]+)\/$/) do |path|
          RaceListPage.new(path[1])
        end
      end

      @race_list_pages.compact!
      if @race_list_pages.empty?
        @race_list_pages = nil
      end
    end

    def _build_url
      url = "https://keiba.yahoo.co.jp/schedule/list/#{@date.year}/?month=#{@date.month}"
    end

    def _build_s3_path
      "schedule.#{@date.strftime('%Y%m')}.html"
    end

  end
end
