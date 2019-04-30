class RaceRefunds < ActiveRecord::Migration[5.2]
  def change
    create_table :race_refunds do |t|
      t.belongs_to :race_meta, index: true, foreign_key: true
      t.string :refund_type
      t.string :horse_numbers
      t.integer :money

      t.timestamps
    end
  end
end
