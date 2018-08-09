class EntryPage
  extend ActiveSupport::Concern

  attr_reader :entry_id

  def initialize(entry_id)
    @entry_id = entry_id
  end

end
