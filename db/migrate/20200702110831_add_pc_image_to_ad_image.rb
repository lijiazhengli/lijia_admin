class AddPcImageToAdImage < ActiveRecord::Migration[6.0]
  def change
  	add_column :ad_images, :pc_image, :string
  end
end
