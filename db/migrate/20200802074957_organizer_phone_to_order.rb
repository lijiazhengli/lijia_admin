class OrganizerPhoneToOrder < ActiveRecord::Migration[6.0]
  def change
  	add_column :orders, :organizer_phone_number, :string
  	add_column :orders, :organizer_name, :string
  end
end
