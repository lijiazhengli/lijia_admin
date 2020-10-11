class CreateProductSetImages < ActiveRecord::Migration[6.0]
  def change
    create_table :product_set_images do |t|
      t.integer  :product_set_id
      t.string   :mobile_image
      t.integer  :position, default: 999
      t.boolean  :active
      t.timestamps
    end

    add_index :product_set_images, :product_set_id
  end
end
