module ScoringHorseRacing::Rule
  class TrainerPage

    attr_reader :trainer_id, :trainer_name

    def initialize(trainer_id, content = nil, downloader, repo)
      @trainer_id = trainer_id
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
      ((not @trainer_id.nil?) \
        && (not @trainer_name.nil?))
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
      if not obj.instance_of?(TrainerPage)
        return false
      end

      if @trainer_id != obj.trainer_id \
        || @trainer_name != obj.trainer_name
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
        @trainer_name = h1.text.strip
      end
    end

    def _build_url
      "https://keiba.yahoo.co.jp/directory/trainer/#{@trainer_id}/"
    end

    def _build_s3_path
      Rails.application.secrets.s3_folder + "/trainer/trainer.#{trainer_id}.html"
    end

  end
end
