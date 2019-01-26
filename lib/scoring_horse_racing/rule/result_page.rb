require "nokogiri"

module ScoringHorseRacing::Rule
  class ResultPage

    attr_reader :result_id, :race_number, :race_name, :start_datetime, :entry_page, :odds_win_page

    def initialize(result_id, content, downloader, repo)
      @result_id = result_id
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
      ((not @result_id.nil?) \
        && (not @race_number.nil?) \
        && (not @race_name.nil?) \
        && (not @start_datetime.nil?))
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
      if not obj.instance_of?(ResultPage)
        return false
      end

      if @result_id != obj.result_id \
        || @race_number != obj.race_number \
        || @race_name != obj.race_name \
        || @start_datetime != obj.start_datetime \
        || @entry_page.nil? != obj.entry_page.nil? \
        || @odds_win_page.nil? != obj.odds_win_page.nil?
        return false
      end

      if (not @entry_page.nil?) && (not obj.entry_page.nil?)
        if not @entry_page.same?(obj.entry_page)
          return false
        end
      end

      if (not @odds_win_page.nil?) && (not obj.odds_win_page.nil?)
        if not @odds_win_page.same?(obj.odds_win_page)
          return false
        end
      end

      true
    end

    private

    def _parse
      if @content.nil?
        return nil
      end

      doc = Nokogiri::HTML.parse(@content, nil, "UTF-8")

      doc.xpath("//td[@id='raceNo']").each do |td|
        td.text.match(/^([0-9]+)R$/) do |race_number|
          @race_number = race_number[1].to_i
        end
      end

      doc.xpath("//p[@id='raceTitDay']").each do |p|
        date = p.children[0].text.strip.match(/^([0-9]+)年([0-9]+)月([0-9]+)日/) do |date_part|
          Time.new(date_part[1].to_i, date_part[2].to_i, date_part[3].to_i)
        end

        time = p.children[4].text.strip.match(/^([0-9]+):([0-9]+)発走/) do |time_part|
          Time.new(1900, 1, 1, time_part[1].to_i, time_part[2].to_i, 0)
        end

        if (not date.nil?) && (not time.nil?)
          @start_datetime = Time.new(date.year, date.month, date.day, time.hour, time.min, 0)
        end
      end

      doc.xpath("//h1[@class='fntB']").map do |h1|
        @race_name = h1.text.strip
      end

      doc.xpath("//div[@id='raceNavi']/ul/li/a").each do |a|
        if a.text == "出馬表"
          entry_id = a["href"].match(/\/race\/denma\/([0-9]+)\//)[1]
          @entry_page = EntryPage.new(entry_id, nil, @downloader, @repo)
        elsif a.text == "オッズ"
          odds_win_id = a["href"].match(/\/odds\/tfw\/([0-9]+)\//)[1]
          @odds_win_page = OddsWinPage.new(odds_win_id, nil, @downloader, @repo)
        end
      end
    end

    def _build_url
      "https://keiba.yahoo.co.jp/race/result/#{@result_id}/"
    end

    def _build_s3_path
      "result.#{@result_id}.html"
    end

  end
end
