class HorsePage
  extend ActiveSupport::Concern

  attr_reader :horse_id

  def initialize(horse_id)
    @horse_id = horse_id
  end

end
