class AddProfessionToUser < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :profession, :string
  	add_column :users, :address_province, :string
  	add_column :users, :address_city, :string
  	add_column :users, :address_district, :string
  	add_column :users, :avatar, :string
  end
end
