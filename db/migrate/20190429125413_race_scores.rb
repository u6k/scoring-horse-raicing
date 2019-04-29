class RaceScores < ActiveRecord::Migration[5.2]
  def change
    create_table :race_scores do |t|
      t.belongs_to :race_meta, index: true, foreign_key: true
      t.integer :rank
      t.integer :bracket_number
      t.integer :horse_number
      t.float :time

      t.timestamps
    end
  end
end
