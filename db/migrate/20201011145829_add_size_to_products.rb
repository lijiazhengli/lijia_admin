class AddSizeToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :size, :string, default: ''
  end
end
