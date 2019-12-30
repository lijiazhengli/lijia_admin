class CreateAdImages < ActiveRecord::Migration[6.0]
  def change
    create_table :ad_images do |t|
      t.string :title
      t.string :ad_type
      t.string :url
      t.string :mobile_image
      t.boolean :active
      t.timestamps
    end
    add_index :ad_images, [:ad_type, :active]
  end
end