class SchedulePage
  extend ActiveSupport::Concern

  def initialize(year, month, content = nil)
    @date = Time.zone.local(year, month, 1)
    @content = content
  end

  def download!
    url = "https://keiba.yahoo.co.jp/schedule/list/#{@date.year}/?month=#{@date.month}"
    @content = NetModule.download_with_get(url)
  end

  def exists?
    NetModule.get_s3_bucket.object(_build_s3_name).exists?
  end

  def valid?
    if @content.nil? && exists?
      @content = NetModule.get_s3_object(NetModule.get_s3_bucket, _build_s3_name)
    end

    if @content.nil?
      false
    else
      true # FIXME
    end
  end

  def parse
    if not valid?
      raise "Content not cached"
    end

    [] # FIXME
  end

  def save!
    if not valid?
      raise "Content not downloaded"
    end

    NetModule.put_s3_object(NetModule.get_s3_bucket, _build_s3_name, @content)
  end

  def self.find_all
    NetModule.get_s3_bucket.objects(prefix: "html/schedule/schedule.").map do |s3_obj|
      date_str = s3_obj.key.match(/schedule\.([0-9]+)\.html/)[1]
      SchedulePage.new(date_str[0..3].to_i, date_str[4..5].to_i)
    end
  end

  private

  def _build_s3_name
    "html/schedule/schedule.#{@date.strftime('%Y%m')}.html"
  end

end
