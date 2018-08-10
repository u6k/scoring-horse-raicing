class OddsWinPage
  extend ActiveSupport::Concern

  attr_reader :odds_id, :win_results, :place_results, :bracket_quinella_results

  def self.find_all
    odds_win_pages = NetModule.get_s3_bucket.objects(prefix: "html/odds_win/odds_win.").map do |s3_obj|
      s3_obj.key.match(/odds_win\.([0-9]+)\.html$/) do |path|
        OddsWinPage.new(path[1])
      end
    end

    odds_win_pages.compact
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
      && (not @win_results.nil?) \
      && (not @place_results.nil?) \
      && (not @bracket_quinella_results.nil?))
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
    if not obj.instance_of?(OddsWinPage)
      return false
    end

    if @odds_id != obj.odds_id \
      || @win_results.nil? != obj.win_results.nil? \
      || @place_results.nil? != obj.place_results.nil? \
      || @bracket_quinella_results.nil? != obj.bracket_quinella_results.nil?
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

    doc.xpath("//h3[@class='midashi3rd mgnBS']").each do |h3|
      @win_results = h3.text # FIXME
      @place_results = h3.text # FIXME
      @bracket_quinella_results = h3.text # FIXME
    end
  end

  def _build_url
    "https://keiba.yahoo.co.jp/odds/tfw/#{@odds_id}/"
  end

  def _build_s3_path
    "html/odds_win/odds_win.#{@odds_id}.html"
  end

end
