class CreateRaceListPages < ActiveRecord::Migration[5.2]
  def change
    create_table :race_list_pages do |t|
      t.string :url
      t.string :course_name
      t.references :schedule_page, foreign_key: true

      t.timestamps
    end
  end
end
