require "logger"

require "scoring_horse_racing/version"

require "scoring_horse_racing/cli"

require "scoring_horse_racing/rule/entry_page"
require "scoring_horse_racing/rule/horse_page"
require "scoring_horse_racing/rule/jockey_page"
require "scoring_horse_racing/rule/odds_exacta_page"
require "scoring_horse_racing/rule/odds_quinella_page"
require "scoring_horse_racing/rule/odds_quinella_place_page"
require "scoring_horse_racing/rule/odds_trifecta_page"
require "scoring_horse_racing/rule/odds_trio_page"
require "scoring_horse_racing/rule/odds_win_page"
require "scoring_horse_racing/rule/race_list_page"
require "scoring_horse_racing/rule/result_page"
require "scoring_horse_racing/rule/schedule_page"
require "scoring_horse_racing/rule/trainer_page"

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