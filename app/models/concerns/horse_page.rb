class HorsePage
  extend ActiveSupport::Concern

  attr_reader :horse_id, :horse_name

  def self.find_all
    horse_pages = NetModule.get_s3_bucket.objects(prefix: "html/horse/horse.").map do |s3_obj|
      s3_obj.key.match(/horse\.([0-9]+)\.html$/) do |path|
        HorsePage.new(path[1])
      end
    end

    horse_pages.compact
  end

  def initialize(horse_id, content = nil)
    @horse_id = horse_id
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
    ((not @horse_id.nil?) \
      && (not @horse_name.nil?))
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

  def _build_url
    "https://keiba.yahoo.co.jp/directory/horse/#{@horse_id}/"
  end

  def _build_s3_path
    "html/horse/horse.#{horse_id}.html"
  end

end
