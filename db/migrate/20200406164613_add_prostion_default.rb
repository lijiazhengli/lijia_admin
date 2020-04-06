class AddProstionDefault < ActiveRecord::Migration[6.0]
  def change
  	change_column_default :franchises, :position, 999
  	change_column_default :franchise_images, :position, 999
  	change_column_default :product_images, :position, 999
  	change_column_default :teachers, :position, 999
  	change_column_default :franchises, :position, 999
  end
end
