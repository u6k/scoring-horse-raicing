namespace :crawl do

  def build_error_log(e)
    "#{e.class} (#{e.message}):\n#{e.backtrace.join("\n")}"
  end

  task :download_schedule_pages, [:year, :month, :missing_only] => :environment do |task, args|
    Rails.logger.info "download_schedule_pages: start: year=#{args.year}, month=#{args.month}, missing_only=#{args.missing_only}"

    # setup
    if args.year.nil? || args.month.nil?
      target_date = Time.zone.local(1986, 1, 1, 0, 0, 0)
      end_date = Time.zone.local(Time.zone.now.year, Time.zone.now.month, 1, 0, 0, 0)
    else
      target_date = Time.zone.local(args.year, args.month, 1, 0, 0, 0)
      end_date = Time.zone.local(args.year, args.month, 1, 0, 0, 0)
    end

    missing_only = (args.missing_only == "false" ? false : true)

    Rails.logger.info "download_schedule_pages: args: target_date=#{target_date.strftime('%Y%m%d')}, missing_only=#{missing_only}"

    # setting download scope
    dates = []
    while (target_date <= end_date) do
      dates << target_date
      target_date += 1.month
    end

    Rails.logger.info "download_schedule_pages: download scope: dates=#{dates}"

    # download
    task_failed = false
    dates.each.with_index(1) do |date, index|
      Rails.logger.info "download_schedule_pages: #{index}/#{dates.length}: start: date=#{date.strftime('%Y%m')}"
      begin
        schedule_page = SchedulePage.new(date.year, date.month)
        if missing_only && schedule_page.exists?
          Rails.logger.info "download_schedule_pages: #{index}/#{dates.length}: skip"
        else
          schedule_page.download_from_web!
          schedule_page.save!
          Rails.logger.info "download_schedule_pages: #{index}/#{dates.length}: end"
        end
      rescue => e
        Rails.logger.error build_error_log(e)
        task_failed = true
      end
    end

    Rails.logger.info "download_schedule_pages: end"
    raise "failed" if task_failed
  end

  task :download_race_list_pages, [:year, :month, :race_id, :missing_only] => :environment do |task, args|
    Rails.logger.info "download_race_list_pages: start: year=#{args.year}, month=#{args.month}, race_id=#{args.race_id}, missing_only=#{args.missing_only}"

    # setup
    if (not args.year.nil?) || (not args.month.nil?)
      Rails.logger.info "download_race_list_pages: setup: year=#{args.year}, month=#{args.month}"

      Rails.logger.info "download_race_list_pages: setup: schedule_page download_from_s3"
      schedule_page = SchedulePage.new(args.year.to_i, args.month.to_i)
      schedule_page.download_from_s3!

      race_list_pages = schedule_page.race_list_pages
    elsif (not args.race_id.nil?)
      Rails.logger.info "download_race_list_pages: setup: race_id=#{args.race_id}"

      race_list_pages = [RaceListPage.new(args.race_id)]
    else
      Rails.logger.info "download_race_list_pages: setup: all period"

      race_list_pages = []
      schedule_pages = SchedulePage.find_all
      schedule_pages.each.with_index(1) do |schedule_page, index|
        Rails.logger.info "download_race_list_pages: setup: schedule_page download_from_s3: #{index}/#{schedule_pages.length}"

        schedule_page.download_from_s3!
        race_list_pages += schedule_page.race_list_pages
      end
    end

    missing_only = (args.missing_only == "false" ? false : true)

    # race_list_page download from web
    task_failed = false
    race_list_pages.each.with_index(1) do |race_list_page, index|
      Rails.logger.info "download_race_list_pages: race_list_page download: #{index}/#{race_list_pages.length}: race_id=#{race_list_page.race_id}"
      begin
        if missing_only && race_list_page.exists?
          Rails.logger.info "download_race_list_pages: race_list_page download: #{index}/#{race_list_pages.length}: skip"
        else
          race_list_page.download_from_web!
          race_list_page.save!
          Rails.logger.info "download_race_list_pages: race_list_page download: #{index}/#{race_list_pages.length}: download and saved"
        end
      rescue => e
        Rails.logger.error build_error_log(e)
        task_failed = true
      end
    end

    Rails.logger.info "download_race_list_pages: end"
    raise "failed" if task_failed
  end

  task :download_race_pages, [:year, :month, :result_id, :missing_only] => :environment do |task, args|
    Rails.logger.info "download_race_pages: start: year=#{args.year}, month=#{args.month}, result_id=#{args.result_id}, missing_only=#{args.missing_only}"

    # setup
    if (not args.year.nil?) || (not args.month.nil?)
      Rails.logger.info "download_race_pages: setup: year=#{args.year}, month=#{args.month}"

      Rails.logger.info "download_race_pages: setup: schedule_page download_from_s3"
      schedule_page = SchedulePage.new(args.year.to_i, args.month.to_i)
      schedule_page.download_from_s3!

      result_pages = []
      race_list_pages = schedule_page.race_list_pages
      race_list_pages.each.with_index(1) do |race_list_page, index|
        Rails.logger.info "download_race_pages: setup: race_list_page download_from_s3: #{index}/#{race_list_pages.length}"

        race_list_page.download_from_s3!
        result_pages += race_list_page.result_pages
      end
    elsif not args.result_id.nil?
      Rails.logger.info "download_race_pages: setup: result_id=#{args.result_id}"

      result_pages = [ResultPage.new(args.result_id)]
    else
      Rails.logger.info "download_race_pages: setup: all period"

      race_list_pages = []
      schedule_pages = SchedulePage.find_all
      schedule_pages.each.with_index(1) do |schedule_page, index|
        Rails.logger.info "download_race_pages: setup: schedule_page download_from_s3: #{index}/#{schedule_pages.length}"

        schedule_page.download_from_s3!
        race_list_pages += schedule_page.race_list_pages
      end

      result_pages = []
      race_list_pages.each.with_index(1) do |race_list_page, index|
        Rails.logger.info "download_race_pages: setup: race_list_page download_from_s3: #{index}/#{race_list_pages.length}"

        race_list_page.download_from_s3!
        result_pages += race_list_page.result_pages
      end
    end

    missing_only = (args.missing_only == "false" ? false : true)

    # page download from web
    task_failed = false
    result_pages.each.with_index(1) do |result_page, index|
      Rails.logger.info "download_race_pages: download: #{index}/#{result_pages.length}: start"
      begin
        if missing_only && result_page.exists?
          result_page.download_from_s3!
          Rails.logger.info "download_race_pages: download: #{index}/#{result_pages.length}: result_page skip"
        else
          result_page.download_from_web!
          result_page.save!
          Rails.logger.info "download_race_pages: download: #{index}/#{result_pages.length}: result_page end"
        end

        entry_page = result_page.entry_page
        if not entry_page.nil?
          if missing_only && entry_page.exists?
            entry_page.download_from_s3!
            Rails.logger.info "download_race_pages: download: #{index}/#{result_pages.length}: entry_page skip"
          else
            entry_page.download_from_web!
            entry_page.save!
            Rails.logger.info "download_race_pages: download: #{index}/#{result_pages.length}: entry_page end"
          end

          entry_page.entries.each.with_index(1) do |entry, sub_index|
            horse_page = entry[:horse]
            if missing_only && horse_page.exists?
              horse_page.download_from_s3!
              Rails.logger.info "download_race_pages: download: #{index}/#{result_pages.length}: horse_page: #{sub_index}/#{entry_page.entries.length}: skip"
            else
              horse_page.download_from_web!
              horse_page.save!
              Rails.logger.info "download_race_pages: download: #{index}/#{result_pages.length}: horse_page: #{sub_index}/#{entry_page.entries.length}: end"
            end

            jockey_page = entry[:jockey]
            if missing_only && jockey_page.exists?
              jockey_page.download_from_s3!
              Rails.logger.info "download_race_pages: download: #{index}/#{result_pages.length}: jockey_page: #{sub_index}/#{entry_page.entries.length}: skip"
            else
              jockey_page.download_from_web!
              jockey_page.save!
              Rails.logger.info "download_race_pages: download: #{index}/#{result_pages.length}: jockey_page: #{sub_index}/#{entry_page.entries.length}: end"
            end

            trainer_page = entry[:trainer]
            if missing_only && trainer_page.exists?
              trainer_page.download_from_s3!
              Rails.logger.info "download_race_pages: download: #{index}/#{result_pages.length}: trainer_page: #{sub_index}/#{entry_page.entries.length}: skip"
            else
              trainer_page.download_from_web!
              trainer_page.save!
              Rails.logger.info "download_race_pages: download: #{index}/#{result_pages.length}: trainer_page: #{sub_index}/#{entry_page.entries.length}: end"
            end
          end
        end

        odds_win_page = result_page.odds_win_page
        if not odds_win_page.nil?
          if missing_only && odds_win_page.exists?
            odds_win_page.download_from_s3!
            Rails.logger.info "download_race_pages: download: #{index}/#{result_pages.length}: odds_win_page skip"
          else
            odds_win_page.download_from_web!
            odds_win_page.save!
            Rails.logger.info "download_race_pages: download: #{index}/#{result_pages.length}: odds_win_page end"
          end
        end

        odds_quinella_page = odds_win_page.odds_quinella_page
        if not odds_quinella_page.nil?
          if missing_only && odds_quinella_page.exists?
            odds_quinella_page.download_from_s3!
            Rails.logger.info "download_race_pages: download: #{index}/#{result_pages.length}: odds_quinella_page skip"
          else
            odds_quinella_page.download_from_web!
            odds_quinella_page.save!
            Rails.logger.info "download_race_pages: download: #{index}/#{result_pages.length}: odds_quinella_page end"
          end
        end

        odds_exacta_page = odds_win_page.odds_exacta_page
        if not odds_exacta_page.nil?
          if missing_only && odds_exacta_page.exists?
            odds_exacta_page.download_from_s3!
            Rails.logger.info "download_race_pages: download: #{index}/#{result_pages.length}: odds_exacta_page skip"
          else
            odds_exacta_page.download_from_web!
            odds_exacta_page.save!
            Rails.logger.info "download_race_pages: download: #{index}/#{result_pages.length}: odds_exacta_page end"
          end
        end

        odds_quinella_place_page = odds_win_page.odds_quinella_place_page
        if not odds_quinella_place_page.nil?
          if missing_only && odds_quinella_place_page.exists?
            odds_quinella_place_page.download_from_s3!
            Rails.logger.info "download_race_pages: download: #{index}/#{result_pages.length}: odds_quinella_place_page skip"
          else
            odds_quinella_place_page.download_from_web!
            odds_quinella_place_page.save!
            Rails.logger.info "download_race_pages: download: #{index}/#{result_pages.length}: odds_quinella_place_page end"
          end
        end

        odds_trio_page = odds_win_page.odds_trio_page
        if not odds_trio_page.nil?
          if missing_only && odds_trio_page.exists?
            odds_trio_page.download_from_s3!
            Rails.logger.info "download_race_pages: download: #{index}/#{result_pages.length}: odds_trio_page skip"
          else
            odds_trio_page.download_from_web!
            odds_trio_page.save!
            Rails.logger.info "download_race_pages: download: #{index}/#{result_pages.length}: odds_trio_page end"
          end
        end

        odds_trifecta_page = odds_win_page.odds_trifecta_page
        if not odds_trifecta_page.nil?
          if missing_only && odds_trifecta_page.exists?
            odds_trifecta_page.download_from_s3!
            Rails.logger.info "download_race_pages: download: #{index}/#{result_pages.length}: odds_trifecta_page skip"
          else
            odds_trifecta_page.download_from_web!
            odds_trifecta_page.save!
            Rails.logger.info "download_race_pages: download: #{index}/#{result_pages.length}: odds_trifecta_page end"
          end

          odds_trifecta_page.odds_trifecta_pages.each do |horse_number, odds_trifecta_sub_page|
            if missing_only && odds_trifecta_sub_page.exists?
              odds_trifecta_sub_page.download_from_s3!
              Rails.logger.info "download_race_pages: download: #{index}/#{result_pages.length}: odds_trifecta_sub_page: #{horse_number}/#{odds_trifecta_sub_page.horse_number}: skip"
            else
              odds_trifecta_sub_page.download_from_web!
              odds_trifecta_sub_page.save!
              Rails.logger.info "download_race_pages: download: #{index}/#{result_pages.length}: odds_trifecta_sub_page: #{horse_number}/#{odds_trifecta_sub_page.horse_number}: end"
            end
          end
        end
      rescue => e
        Rails.logger.error build_error_log(e)
        task_failed = true
      end
    end

    Rails.logger.info "download_result_pages: end"
    raise "failed" if task_failed
  end

end
