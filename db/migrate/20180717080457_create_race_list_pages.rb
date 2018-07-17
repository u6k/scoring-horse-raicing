class CreateRaceListPages < ActiveRecord::Migration[5.2]
  def change
    create_table :race_list_pages do |t|
      t.datetime :date

      t.timestamps
    end
  end
end
