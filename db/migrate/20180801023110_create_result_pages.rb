class CreateResultPages < ActiveRecord::Migration[5.2]
  def change
    create_table :result_pages do |t|
      t.string :url
      t.integer :race_number
      t.string :race_name

      t.timestamps
    end
  end
end
