require "nokogiri"

module ScoringHorseRacing::Rule
  class JockeyPage

    attr_reader :jockey_id, :jockey_name

    def initialize(jockey_id, content = nil, downloader, repo)
      @jockey_id = jockey_id
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
      ((not @jockey_id.nil?) \
        && (not @jockey_name.nil?))
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
      if not obj.instance_of?(JockeyPage)
        return false
      end

      if @jockey_id != obj.jockey_id \
        || @jockey_name != obj.jockey_name
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

      doc.xpath("//div[@id='dirTitName']/h1").each do |h1|
        @jockey_name = h1.text.strip
      end
    end

    def _build_url
      "https://keiba.yahoo.co.jp/directory/jocky/#{@jockey_id}/"
    end

    def _build_s3_path
      Rails.application.secrets.s3_folder + "/jockey/jockey.#{jockey_id}.html"
    end

  end
end
