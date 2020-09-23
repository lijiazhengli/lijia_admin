class CreateApplies < ActiveRecord::Migration[6.0]
  def change
    create_table :applies do |t|
      t.integer :user_id
      t.integer :admin_id
      t.string :item_type
      t.string :status, default: 'unconfirmed'
      t.float  :cost
      t.text   :notes
      t.timestamps
    end

    create_table :apply_items do |t|
      t.integer :apply_id
      t.string :item_type
      t.integer :item_id
    end

    add_index :applies, :user_id
    add_index :applies, [:item_type, :status]
    add_index :apply_items, :apply_id
  end
end
