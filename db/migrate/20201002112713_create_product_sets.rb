class CreateProductSets < ActiveRecord::Migration[6.0]
  def change
    create_table :product_sets do |t|
      t.string :title
      t.text   :description
      t.string :front_image
      t.string :detailed_image
      t.integer :position, default: 999
      t.boolean :active
      t.timestamps
    end

    add_column :products, :product_set_id, :integer
    add_index :products, :product_set_id
  end
end
