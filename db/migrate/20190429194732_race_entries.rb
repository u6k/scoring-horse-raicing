class RaceEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :race_entries do |t|
      t.belongs_to :race_meta, index: true, foreign_key: true
      t.integer :bracket_number
      t.integer :horse_number
      t.string :horse_id
      t.string :horse_name
      t.string :gender
      t.integer :age
      t.string :coat_color
      t.string :trainer_id
      t.string :trainer_name
      t.integer :horse_weight
      t.string :jockey_id
      t.string :jockey_name
      t.float :jockey_weight
      t.string :father_horse_name
      t.string :mother_horse_name

      t.timestamps
    end
  end
end
