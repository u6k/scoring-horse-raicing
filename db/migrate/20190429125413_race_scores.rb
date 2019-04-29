class RaceScores < ActiveRecord::Migration[5.2]
  def change
    create_table :race_scores do |t|
      t.string :race_id
      t.integer :rank
      t.integer :bracket_number
      t.integer :horse_number
      t.float :time
    end
  end
end
