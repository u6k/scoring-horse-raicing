class CreateRefundListPages < ActiveRecord::Migration[5.2]
  def change
    create_table :refund_list_pages do |t|
      t.string :url
      t.references :race_list_page, foreign_key: true

      t.timestamps
    end
  end
end
