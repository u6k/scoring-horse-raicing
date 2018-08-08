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

  task :download_race_list_pages, [:year, :month, :missing_only] => :environment do |task, args|
    Rails.logger.info "download_race_list_pages: start: year=#{args.year}, month=#{args.month}, missing_only=#{args.missing_only}"

    # setup
    if args.year.nil? || args.month.nil?
      schedule_pages = SchedulePage.find_all
    else
      schedule_pages = [SchedulePage.new(args.year.to_i, args.month.to_i)]
    end

    missing_only = (args.missing_only == "false" ? false : true)

    Rails.logger.info "download_race_list_pages: args: schedule_pages=#{schedule_pages.map{|s|s.date.strftime('%Y%m')}}, missing_only=#{missing_only}"

    # schedule_page download from s3
    race_list_pages = []

    schedule_pages.each.with_index(1) do |schedule_page, index|
      Rails.logger.info "download_race_list_pages: schedule_page download from s3: #{index}/#{schedule_pages.length}: date=#{schedule_page.date.strftime('%Y%m')}"

      schedule_page.download_from_s3!

      race_list_pages += schedule_page.race_list_pages
    end

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

  task :download_result_pages, [:year, :month, :day, :course_name] => :environment do |task, args|
    Rails.logger.info "download_result_pages: start: year=#{args.year}, month=#{args.month}, day=#{args.day}, course_name=#{args.course_name}"

    if args.year.nil? || args.month.nil?
      race_list_pages = RaceListPage.all
    elsif args.day.nil? || args.course_name.nil?
      race_list_pages = SchedulePage.find_by_date(args.year, args.month).race_list_pages
    else
      race_list_pages = RaceListPage.where(date: Time.zone.local(args.year, args.month, args.day, 0, 0, 0), course_name: args.course_name)
    end

    task_failed = false
    race_list_pages.each.with_index(1) do |race_list_page, index|
      Rails.logger.info "download_result_pages: #{index}/#{race_list_pages.length}: start: date=#{race_list_page.date.strftime('%Y%m%d')}, course_name=#{race_list_page.course_name}"
      begin
        result_pages = race_list_page.download_result_pages
        result_pages.each { |r| r.save! }
        Rails.logger.info "download_result_pages: #{index}/#{race_list_pages.length}: end"
      rescue => e
        Rails.logger.error build_error_log(e)
        task_failed = true
      end
    end

    Rails.logger.info "download_result_pages: end"
    raise "failed" if task_failed
  end

end
