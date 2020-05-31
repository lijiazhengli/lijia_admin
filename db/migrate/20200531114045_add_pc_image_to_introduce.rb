class AddPcImageToIntroduce < ActiveRecord::Migration[6.0]
  def change
  	add_column :introduces, :pc_image, :string
  	add_column :products, :pc_front_image, :string
  	add_column :products, :pc_detailed_image, :string
  end
end
