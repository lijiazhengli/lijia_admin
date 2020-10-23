class AddAddressCityArranger < ActiveRecord::Migration[6.0]
  def change
    add_column :arrangers, :address_city, :string, default: nil
  end
end
