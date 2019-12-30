class AddWxMaIdToUser < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :wx_ma_id, :string, limit: 50
    add_index :users, :wx_ma_id
    add_column :users, :wx_union_id, :string, limit: 50
    add_index :users, :wx_union_id
    add_column :users, :source, :string, limit: 50
  end
end
