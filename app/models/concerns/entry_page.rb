class EntryPage
  extend ActiveSupport::Concern

  def initialize(entry_id)
    @entry_id = entry_id
  end

end
