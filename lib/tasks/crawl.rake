namespace :crawl do

  task :download_schedule_pages, [:year, :month] => :environment do |task, args|
    Rails.logger.info "download_schedule_pages: start: year=#{args.year}, month=#{args.month}"

    if args.year.nil? || args.month.nil?
      target_date = Time.zone.local(1986, 1, 1, 0, 0, 0)
      end_date = Time.zone.local(Time.zone.now.year, Time.zone.now.month, 1, 0, 0, 0)
    else
      target_date = Time.zone.local(args.year, args.month, 1, 0, 0, 0)
      end_date = Time.zone.local(args.year, args.month, 1, 0, 0, 0)
    end

    dates = []
    while (target_date <= end_date) do
      dates << target_date
      target_date += 1.month
    end

    task_failed = false
    dates.each.with_index(1) do |date,index|
      Rails.logger.info "download_schedule_pages: #{index}/#{dates.length}: start: date=#{date.strftime('%Y%m')}"
      begin
        schedule_page = SchedulePage.download(date.year, date.month)
        schedule_page.save!
        Rails.logger.info "download_schedule_pages: #{index}/#{dates.length}: end"
      rescue => e
        Rails.logger.error build_error_log(e)
        task_failed = true
      end
    end

    Rails.logger.info "download_schedule_pages: end"
    raise "failed" if task_failed
  end

end
