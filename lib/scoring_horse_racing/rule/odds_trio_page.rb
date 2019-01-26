require "nokogiri"

module ScoringHorseRacing::Rule
  class OddsTrioPage

    attr_reader :odds_id, :trio_results

    def initialize(odds_id, content, downloader, repo)
      @odds_id = odds_id
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

    def valid?
      ((not @odds_id.nil?) \
        && (not @trio_results.nil?))
    end

    def exists?
      @repo.exists_s3_object?(_build_s3_path)
    end

    def save!
      if not valid?
        raise "Invalid"
      end

      @repo.put_s3_object(_build_s3_path, @content)
    end

    def same?(obj)
      if not obj.instance_of?(OddsTrioPage)
        return false
      end

      if @odds_id != obj.odds_id \
        || @trio_results.nil? != obj.trio_results.nil?
        return false
      end

      true
    end

    private

    def _parse
      if @content.nil?
        return nil
      end

      doc = Nokogiri::HTML.parse(@content, nil, "UTF-8")

      doc.xpath("//li[@id='raceNavi2C']/a").each do |a|
        @trio_results = a.text
      end
    end

    def _build_url
      "https://keiba.yahoo.co.jp/odds/ut/#{@odds_id}/"
    end

    def _build_s3_path
      "odds_trio.#{@odds_id}.html"
    end

  end
end
