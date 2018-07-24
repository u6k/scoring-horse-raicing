class CreateEntryListPages < ActiveRecord::Migration[5.2]
  def change
    create_table :entry_list_pages do |t|
      t.integer :race_number
      t.string :race_name
      t.string :url
      t.references :race_list_page, foreign_key: true

      t.timestamps
    end
  end
end
