class AddTypeToProductSet < ActiveRecord::Migration[6.0]
  def change
    add_column :product_sets, :type, :string, default: 'GoodSet'
    add_column :product_sets, :home_icon, :string, default: nil
    add_column :product_sets, :notes, :text
  end
end
