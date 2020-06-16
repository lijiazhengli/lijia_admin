class AddWebContentToProduct < ActiveRecord::Migration[6.0]
  def change
  	add_column :products, :web_content, :text
  end
end
