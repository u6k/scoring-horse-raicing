class CreateSchedulePages < ActiveRecord::Migration[5.2]
  def change
    create_table :schedule_pages do |t|
      t.string :url
      t.datetime :datetime

      t.timestamps
    end
  end
end
