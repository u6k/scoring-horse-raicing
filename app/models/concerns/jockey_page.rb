class JockeyPage
  extend ActiveSupport::Concern

  attr_reader :jockey_id, :jockey_name

  def self.find_all
    jockey_pages = NetModule.get_s3_bucket.objects(prefix: "html/jockey/jockey.").map do |s3_obj|
      s3_obj.key.match(/jockey\.([0-9]+)\.html$/) do |path|
        JockeyPage.new(path[1])
      end
    end

    jockey_pages.compact
  end

  def initialize(jockey_id, content = nil)
    @jockey_id = jockey_id
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
    ((not @jockey_id.nil?) \
      && (not @jockey_name.nil?))
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
    "html/jockey/jockey.#{jockey_id}.html"
  end

end
