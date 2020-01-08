class CreateProductImages < ActiveRecord::Migration[6.0]
  def change
    create_table :product_images do |t|
      t.integer  :product_id
      t.string   :type
      t.string   :mobile_image
      t.integer  :position
      t.boolean  :active
      t.timestamps
    end
  end
end
