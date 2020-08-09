class AddUrlToIntroduce < ActiveRecord::Migration[6.0]
  def change
  	add_column :introduces, :url, :string
  	add_column :introduces, :position, :integer, default: 999
  	add_column :teachers, :position, :integer, default: 999
  end
end
