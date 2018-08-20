class JockeyPage
  extend ActiveSupport::Concern

  attr_reader :jockey_id, :jockey_name

  def initialize(jockey_id, content = nil)
    @jockey_id = jockey_id
    @content = content

    _parse
  end

  def valid?
    ((not @jockey_id.nil?) \
      && (not @jockey_name.nil?))
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
      @jockey_name = h1.text.strip
    end
  end

  def _build_url
    "https://keiba.yahoo.co.jp/directory/jocky/#{@jockey_id}/"
  end

  def _build_s3_path
    "html/jockey/jockey.#{jockey_id}.html"
  end

end
