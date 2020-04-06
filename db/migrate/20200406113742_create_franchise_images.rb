class CreateFranchiseImages < ActiveRecord::Migration[6.0]
  def change
    create_table :franchise_images do |t|
      t.integer  :franchise_id
      t.string   :mobile_image
      t.integer  :position
      t.boolean  :active
      t.timestamps
    end

    add_index :franchise_images, [:franchise_id, :active]
  end
end
