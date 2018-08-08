class ResultPage
  extend ActiveSupport::Concern

  attr_reader :result_id, :race_number, :race_name, :start_datetime, :entry_page, :odds_win_page

  def initialize(result_id)
    @result_id = result_id
  end

  def valid?
    false
  end

  def exists?
    false
  end

end
