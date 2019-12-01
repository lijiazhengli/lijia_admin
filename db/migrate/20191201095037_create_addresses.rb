class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.integer :user_id
      t.string  :recipient_name
      t.string  :recipient_phone_number
      t.string  :location_title
      t.string  :location_address
      t.string  :location_details
      t.decimal  :gaode_lng, precision: 11, scale: 8
      t.decimal  :gaode_lat, precision: 11, scale: 8
      t.string   :address_province
      t.string   :address_city
      t.string   :address_district
      t.boolean  :is_default,  default: false
      t.integer  :sex
      t.timestamps
    end
    add_index :addresses, [:user_id, :is_default]
  end
end
