class CreateIntroduces < ActiveRecord::Migration[6.0]
  def change
    create_table :introduces do |t|
      t.string :title
      t.string :item_type
      t.string :mobile_image
      t.text   :description
      t.boolean :active
      t.timestamps
    end
    add_index :introduces, [:item_type, :active]
  end
end
