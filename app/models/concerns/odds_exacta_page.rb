class OddsExactaPage
  extend ActiveSupport::Concern

  attr_reader :odds_id

  def initialize(odds_id)
    @odds_id = odds_id
  end

  def same?(obj)
    true
  end

end
