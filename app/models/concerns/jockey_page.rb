class JockeyPage
  extend ActiveSupport::Concern

  attr_reader :jockey_id

  def initialize(jockey_id)
    @jockey_id = jockey_id
  end

end
