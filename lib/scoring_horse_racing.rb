require "logger"

require "scoring_horse_racing/version"

require "scoring_horse_racing/cli"

require "scoring_horse_racing/parser/schedule_page"

module ScoringHorseRacing
  class AppLogger
    @@logger = nil

    def self.get_logger
      if @@logger.nil?
        @@logger = Logger.new(STDOUT)
      end

      @@logger
    end
  end
end
