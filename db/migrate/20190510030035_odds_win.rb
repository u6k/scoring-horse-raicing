class OddsWin < ActiveRecord::Migration[5.2]
  def change
    create_table :odds_wins do |t|
      t.belongs_to :race_meta, index: true, foreign_key: true
      t.integer :horse_number
      t.float :odds

      t.timestamps
    end

    create_table :odds_places do |t|
      t.belongs_to :race_meta, index: true, foreign_key: true
      t.integer :horse_number
      t.float :odds_1
      t.float :odds_2

      t.timestamps
    end

    create_table :odds_bracket_quinellas do |t|
      t.belongs_to :race_meta, index: true, foreign_key: true
      t.integer :bracket_number_1
      t.integer :bracket_number_2
      t.float :odds

      t.timestamps
    end

    create_table :odds_quinellas do |t|
      t.belongs_to :race_meta, index: true, foreign_key: true
      t.integer :horse_number_1
      t.integer :horse_number_2
      t.float :odds

      t.timestamps
    end
  end
end
