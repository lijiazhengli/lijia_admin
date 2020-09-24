class AddStatusToApplyItem < ActiveRecord::Migration[6.0]
  def change
    add_column :apply_items, :status, :string, default: 'unconfirmed'
    add_index :apply_items, :status
    add_index :apply_items, [:item_type, :item_type]
  end
end
