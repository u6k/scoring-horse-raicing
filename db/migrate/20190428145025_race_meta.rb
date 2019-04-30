class RaceMeta < ActiveRecord::Migration[5.2]
  def change
    create_table :race_meta do |t|
      t.string :race_id
      t.integer :race_number
      t.datetime :start_datetime
      t.string :race_name
      t.string :course_name
      t.string :course_length
      t.string :weather
      t.string :course_condition
      t.string :race_class
      t.string :prize_class

      t.timestamps
    end
  end
end
