class AddAreaToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :area, :integer, default: nil, comment: '区域'
  end
end
