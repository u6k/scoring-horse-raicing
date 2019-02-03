require "logger"

require "scoring_horse_racing/version"

require "scoring_horse_racing/cli"

require "scoring_horse_racing/parser/schedule_page"
require "scoring_horse_racing/parser/race_list_page"
require "scoring_horse_racing/parser/result_page"
require "scoring_horse_racing/parser/entry_page"

module ScoringHorseRacing
  class AppLogger
    @@logger = nil

    def self.get_logger
      if @@logger.nil?
        @@logger = Logger.new(STDOUT)
        @@logger.level = "INFO"
      end

      @@logger
    end
  end
end
