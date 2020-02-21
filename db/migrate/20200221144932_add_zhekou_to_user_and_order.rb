class AddZhekouToUserAndOrder < ActiveRecord::Migration[6.0]
  def change
  	add_column :orders, :zhekou, :float, default: 1
  	add_column :users, :zhekou, :float, default: 1
  end
end
