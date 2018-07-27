class CreateOddsWinPages < ActiveRecord::Migration[5.2]
  def change
    create_table :odds_win_pages do |t|
      t.string :url
      t.references :entry_list_page, foreign_key: true

      t.timestamps
    end
  end
end
