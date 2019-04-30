require "logger"
require "thor"
require "crawline"

require "investment_horse_racing/crawler/version"
require "investment_horse_racing/crawler/parser/schedule_page"
require "investment_horse_racing/crawler/parser/race_list_page"
require "investment_horse_racing/crawler/parser/result_page"
require "investment_horse_racing/crawler/parser/entry_page"
require "investment_horse_racing/crawler/parser/horse_page"
require "investment_horse_racing/crawler/parser/jockey_page"
require "investment_horse_racing/crawler/parser/trainer_page"
require "investment_horse_racing/crawler/parser/odds_exacta_page"
require "investment_horse_racing/crawler/parser/odds_quinella_page"
require "investment_horse_racing/crawler/parser/odds_quinella_place_page"
require "investment_horse_racing/crawler/parser/odds_trifecta_page"
require "investment_horse_racing/crawler/parser/odds_trio_page"
require "investment_horse_racing/crawler/parser/odds_win_page"

module InvestmentHorseRacing::Crawler
  class CLI < Thor
    desc "version", "Display version"
    def version
      puts InvestmentHorseRacing::Crawler::VERSION
    end

    desc "crawl", "Crawl horse racing"
    method_option :s3_access_key
    method_option :s3_secret_key
    method_option :s3_region, default: "us-east-1"
    method_option :s3_bucket
    method_option :s3_endpoint, default: "https://s3.amazonaws.com"
    method_option :s3_force_path_style, default: false
    method_option :s3_object_name_prefix, default: nil
    method_option :db_database
    method_option :db_host, default: "localhost"
    method_option :db_port, default: "5432"
    method_option :db_username
    method_option :db_password
    method_option :db_sslmode, default: nil
    method_option :interval, default: "1.0"
    method_option :entrypoint_url, default: "https://keiba.yahoo.co.jp/schedule/list/"
    def crawl
      setup_db_connection(options.db_database, options.db_host, options.db_port, options.db_username, options.db_password, options.db_sslmode)

      engine = setup_crawline_engine(options.s3_access_key, options.s3_secret_key, options.s3_region, options.s3_bucket, options.s3_endpoint, options.s3_force_path_style, options.s3_object_name_prefix, options.interval.to_f)

      engine.crawl(options.entrypoint_url)
    end

    desc "parse", "Parse horse racing"
    method_option :s3_access_key
    method_option :s3_secret_key
    method_option :s3_region, default: "us-east-1"
    method_option :s3_bucket
    method_option :s3_endpoint, default: "https://s3.amazonaws.com"
    method_option :s3_force_path_style, default: false
    method_option :s3_object_name_prefix, default: nil
    method_option :db_database
    method_option :db_host, default: "localhost"
    method_option :db_port, default: "5432"
    method_option :db_username
    method_option :db_password
    method_option :db_sslmode, default: nil
    method_option :entrypoint_url, default: "https://keiba.yahoo.co.jp/schedule/list/"
    def parse
      setup_db_connection(options.db_database, options.db_host, options.db_port, options.db_username, options.db_password, options.db_sslmode)

      engine = setup_crawline_engine(options.s3_access_key, options.s3_secret_key, options.s3_region, options.s3_bucket, options.s3_endpoint, options.s3_force_path_style, options.s3_object_name_prefix, 1.0)

      engine.parse(options.entrypoint_url)
    end

    desc "list_cache_state", "Listing cache state"
    method_option :s3_access_key
    method_option :s3_secret_key
    method_option :s3_region, default: "us-east-1"
    method_option :s3_bucket
    method_option :s3_endpoint, default: "https://s3.amazonaws.com"
    method_option :s3_force_path_style, default: false
    method_option :s3_object_name_prefix, default: nil
    method_option :db_database
    method_option :db_host, default: "localhost"
    method_option :db_port, default: "5432"
    method_option :db_username
    method_option :db_password
    method_option :db_sslmode, default: nil
    method_option :entrypoint_url, default: "https://keiba.yahoo.co.jp/schedule/list/"
    def list_cache_state
      setup_db_connection(options.db_database, options.db_host, options.db_port, options.db_username, options.db_password, options.db_sslmode)

      engine = setup_crawline_engine(options.s3_access_key, options.s3_secret_key, options.s3_region, options.s3_bucket, options.s3_endpoint, options.s3_force_path_style, options.s3_object_name_prefix, 1.0)

      engine.list_cache_state(options.entrypoint_url) do |url, data, parser|
        state = {"url" => url, "state" => (data.nil? ? "not found" : "found"), "timestamp" => (data.nil? ? nil : data["downloaded_timestamp"])}
        puts state.to_json
      end
    end

    private
   
    def setup_crawline_engine(s3_access_key, s3_secret_key, s3_region, s3_bucket, s3_endpoint, s3_force_path_style, s3_object_name_prefix, interval)
      downloader = Crawline::Downloader.new("investment-horse-racing-crawler/#{InvestmentHorseRacing::Crawler::VERSION} (https://redmine.u6k.me/projects/investment-horse-racing-crawler)")

      @repo = Crawline::ResourceRepository.new(options.s3_access_key, options.s3_secret_key, options.s3_region, options.s3_bucket, options.s3_endpoint, options.s3_force_path_style, options.s3_object_name_prefix)

      parsers = {
        /^https:\/\/keiba\.yahoo\.co\.jp\/schedule\/list\/(\d{4}\/\?month=\d{1,2})?$/ => InvestmentHorseRacing::Crawler::Parser::SchedulePageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/race\/list\/\d+\/$/ => InvestmentHorseRacing::Crawler::Parser::RaceListPageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/race\/result\/\d+\/$/ => InvestmentHorseRacing::Crawler::Parser::ResultPageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/race\/denma\/\d+\/$/ => InvestmentHorseRacing::Crawler::Parser::EntryPageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/directory\/horse\/\d+\/$/ => InvestmentHorseRacing::Crawler::Parser::HorsePageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/directory\/jocky\/\d+\/$/ => InvestmentHorseRacing::Crawler::Parser::JockeyPageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/directory\/trainer\/\d+\/$/ => InvestmentHorseRacing::Crawler::Parser::TrainerPageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/odds\/tfw\/\d+\/$/ => InvestmentHorseRacing::Crawler::Parser::OddsWinPageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/odds\/ur\/\d+\/$/ => InvestmentHorseRacing::Crawler::Parser::OddsQuinellaPageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/odds\/wide\/\d+\/$/ => InvestmentHorseRacing::Crawler::Parser::OddsQuinellaPlacePageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/odds\/ut\/\d+\/$/ => InvestmentHorseRacing::Crawler::Parser::OddsExactaPageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/odds\/sf\/\d+\/$/ => InvestmentHorseRacing::Crawler::Parser::OddsTrioPageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/odds\/sf\/\d+\/$/ => InvestmentHorseRacing::Crawler::Parser::OddsTrioPageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/odds\/st\/\d+\/(\?umaBan=\d+)?$/ => InvestmentHorseRacing::Crawler::Parser::OddsTrifectaPageParser,
      }

      engine = Crawline::Engine.new(downloader, @repo, parsers, interval.to_f)
    end

    def setup_db_connection(db_database, db_host, db_port, db_username, db_password, db_sslmode)
      db_config = {
        adapter: "postgresql",
        database: db_database,
        host: db_host,
        port: db_port,
        username: db_username,
        password: db_password,
        sslmode: db_sslmode
      }

      ActiveRecord::Base.establish_connection db_config
    end
  end

  class AppLogger
    @@logger = nil

    def self.get_logger
      if @@logger.nil?
        @@logger = Logger.new(STDOUT)
        @@logger.level = ENV["SHR_LOGGER_LEVEL"] if ENV.has_key?("SHR_LOGGER_LEVEL")
      end

      @@logger
    end
  end
end
