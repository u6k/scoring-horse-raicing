class RaceRefunds < ActiveRecord::Migration[5.2]
  def change
    create_table :race_refunds do |t|
      t.string :race_id
      t.string :type
      t.string :horse_numbers
      t.integer :money
    end
  end
end
