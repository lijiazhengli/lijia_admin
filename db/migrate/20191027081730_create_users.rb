class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :phone_number, limit: 20
      t.string :name
      t.integer :sex
      t.timestamps
    end
    add_index :users, :phone_number
  end
end
