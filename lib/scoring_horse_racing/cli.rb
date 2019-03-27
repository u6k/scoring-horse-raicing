require "thor"
require "crawline"

module ScoringHorseRacing
  class CLI < Thor
    desc "version", "Display version"
    def version
      puts ScoringHorseRacing::VERSION
    end

    desc "crawl", "Crawl"
    method_option :s3_access_key
    method_option :s3_secret_key
    method_option :s3_region
    method_option :s3_bucket
    method_option :s3_endpoint
    method_option :s3_force_path_style
    method_option :interval, default: "1.0"
    method_option :entrypoint_url, default: "https://keiba.yahoo.co.jp/schedule/list/"
    def crawl
      downloader = Crawline::Downloader.new("scoring-horse-racing/#{ScoringHorseRacing::VERSION} (https://redmine.u6k.me/projects/scoring-horse-raicing)")

      repo = Crawline::ResourceRepository.new(options.s3_access_key, options.s3_secret_key, options.s3_region, options.s3_bucket, options.s3_endpoint, options.s3_force_path_style, nil)

      parsers = {
        /^https:\/\/keiba\.yahoo\.co\.jp\/schedule\/list\/(\d{4}\/\?month=\d{1,2})?$/ => ScoringHorseRacing::Parser::SchedulePageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/race\/list\/\d+\/$/ => ScoringHorseRacing::Parser::RaceListPageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/race\/result\/\d+\/$/ => ScoringHorseRacing::Parser::ResultPageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/race\/denma\/\d+\/$/ => ScoringHorseRacing::Parser::EntryPageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/directory\/horse\/\d+\/$/ => ScoringHorseRacing::Parser::HorsePageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/directory\/jocky\/\d+\/$/ => ScoringHorseRacing::Parser::JockeyPageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/directory\/trainer\/\d+\/$/ => ScoringHorseRacing::Parser::TrainerPageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/odds\/tfw\/\d+\/$/ => ScoringHorseRacing::Parser::OddsWinPageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/odds\/ur\/\d+\/$/ => ScoringHorseRacing::Parser::OddsQuinellaPageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/odds\/wide\/\d+\/$/ => ScoringHorseRacing::Parser::OddsQuinellaPlacePageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/odds\/ut\/\d+\/$/ => ScoringHorseRacing::Parser::OddsExactaPageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/odds\/sf\/\d+\/$/ => ScoringHorseRacing::Parser::OddsTrioPageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/odds\/sf\/\d+\/$/ => ScoringHorseRacing::Parser::OddsTrioPageParser,
        /^https:\/\/keiba\.yahoo\.co\.jp\/odds\/st\/\d+\/(\?umaBan=\d+)?$/ => ScoringHorseRacing::Parser::OddsTrifectaPageParser,
      }

      engine = Crawline::Engine.new(downloader, repo, parsers, options.interval.to_f)

      engine.crawl(options.entrypoint_url)
    end
  end
end

