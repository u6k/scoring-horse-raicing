class OddsQuinellaPage
  extend ActiveSupport::Concern

  attr_reader :odds_id, :quinella_results

  def self.find_all
    odds_quinella_pages = NetModule.get_s3_bucket.objects(prefix: "html/odds_quinella/odds_quinella.").map do |s3_obj|
      s3_obj.key.match(/odds_quinella\.([0-9]+)\.html$/) do |path|
        OddsQuinellaPage.new(path[1])
      end
    end

    odds_quinella_pages.compact
  end

  def initialize(odds_id, content = nil)
    @odds_id = odds_id
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
    ((not @odds_id.nil?) \
      && (not @quinella_results.nil?))
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
    if not obj.instance_of?(OddsQuinellaPage)
      return false
    end

    if @odds_id != obj.odds_id \
      || @quinella_results.nil? != obj.quinella_results.nil?
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
      @quinella_results = a.text
    end
  end

  def _build_url
    "https://keiba.yahoo.co.jp/odds/ur/#{@odds_id}/"
  end

  def _build_s3_path
    "html/odds_quinella/odds_quinella.#{@odds_id}.html"
  end

end
