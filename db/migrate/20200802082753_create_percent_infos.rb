class CreatePercentInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :percent_infos do |t|
      t.string  :item_type
      t.integer   :item_id
      t.text   :extend
      t.timestamps
    end
    add_index :percent_infos, [:item_type, :item_id]
    add_column :users, :status, :integer, default: 1
  end
end
