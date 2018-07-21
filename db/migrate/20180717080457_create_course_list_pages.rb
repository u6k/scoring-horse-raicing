class CreateCourseListPages < ActiveRecord::Migration[5.2]
  def change
    create_table :course_list_pages do |t|
      t.datetime :date
      t.string :url

      t.timestamps
    end
  end
end
