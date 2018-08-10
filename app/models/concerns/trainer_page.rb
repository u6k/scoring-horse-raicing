class TrainerPage
  extend ActiveSupport::Concern

  attr_reader :trainer_id

  def initialize(trainer_id)
    @trainer_id = trainer_id
  end

end
