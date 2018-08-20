class HorsePage
  extend ActiveSupport::Concern

  attr_reader :horse_id, :horse_name

  def initialize(horse_id, content = nil)
    @horse_id = horse_id
    @content = content

    _parse
  end

  def valid?
    ((not @horse_id.nil?) \
      && (not @horse_name.nil?))
  end

  def exists?
    NetModule.get_s3_bucket.object(_build_s3_path).exists?
  end

  private

  def _parse
    if @content.nil?
      return nil
    end

    doc = Nokogiri::HTML.parse(@content, nil, "UTF-8")

    doc.xpath("//div[@id='dirTitName']/h1").each do |h1|
      @horse_name = h1.text.strip
    end
  end

  def _build_s3_path
    "html/horse/horse.#{horse_id}.html"
  end

end
