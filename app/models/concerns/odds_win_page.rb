class OddsWinPage
  extend ActiveSupport::Concern

  attr_reader :odds_win_id

  def initialize(odds_win_id)
    @odds_win_id = odds_win_id
  end

end
