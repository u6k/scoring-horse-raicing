class TrainerPage
  extend ActiveSupport::Concern

  attr_reader :trainer_id, :trainer_name

  def self.find_all
    trainer_pages = NetModule.get_s3_bucket.objects(prefix: "html/trainer/trainer.").map do |s3_obj|
      s3_obj.key.match(/trainer\.([0-9]+)\.html$/) do |path|
        TrainerPage.new(path[1])
      end
    end

    trainer_pages.compact
  end

  def initialize(trainer_id, content = nil)
    @trainer_id = trainer_id
    @content = content

    _parse
  end

  def download_from_web!
    @content = NetModule.download_with_get(_build_url)

    _parse
  end

  def download_from_s3!
    @content = NetModule.get_s3_object(NetModule.get_s3_bucket, _build_s3_path)

    _parse
  end

  def valid?
    ((not @trainer_id.nil?) \
      && (not @trainer_name.nil?))
  end

  def exists?
    NetModule.get_s3_bucket.object(_build_s3_path).exists?
  end

  def save!
    if not valid?
      raise "Invalid"
    end

    NetModule.put_s3_object(NetModule.get_s3_bucket, _build_s3_path, @content)
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
    "html/trainer/trainer.#{trainer_id}.html"
  end

end
