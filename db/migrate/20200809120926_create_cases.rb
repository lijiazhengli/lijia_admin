class CreateCases < ActiveRecord::Migration[6.0]
  def change
    create_table :cases do |t|
      t.string :title
      t.string :url
      t.string :description
      t.string :mobile_image
      t.string :pc_image
      t.boolean :active
      t.integer :position, default: 999
      t.timestamps
    end
  end
end
