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

    desc "crawl", "Crawl"
    method_option :s3_access_key
    method_option :s3_secret_key
    method_option :s3_region, default: "us-east-1"
    method_option :s3_bucket
    method_option :s3_endpoint, default: "https://s3.amazonaws.com"
    method_option :s3_force_path_style, default: false
    method_option :s3_object_name_prefix, default: nil
    method_option :interval, default: "1.0"
    method_option :entrypoint_url, default: "https://keiba.yahoo.co.jp/schedule/list/"
    def crawl
      downloader = Crawline::Downloader.new("investment-horse-racing-crawler/#{InvestmentHorseRacing::Crawler::VERSION} (https://redmine.u6k.me/projects/investment-horse-racing-crawler)")

      repo = Crawline::ResourceRepository.new(options.s3_access_key, options.s3_secret_key, options.s3_region, options.s3_bucket, options.s3_endpoint, options.s3_force_path_style, options.s3_object_name_prefix)

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

      engine = Crawline::Engine.new(downloader, repo, parsers, options.interval.to_f)

      engine.crawl(options.entrypoint_url)
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
