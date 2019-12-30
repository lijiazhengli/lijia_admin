class AddSexToOrder < ActiveRecord::Migration[6.0]
  def change
  	add_column :orders, :sex, :integer
  	add_column :orders, :wx_open_id, :string, limit: 50
  	add_column :orders, :purchase_source, :string, limit: 20
  	add_column :orders, :recipient_name, :string
  	add_column :orders, :recipient_phone_number, :string
  	add_column :orders, :address_district, :string

  	add_index :orders, :purchase_source
  end
end