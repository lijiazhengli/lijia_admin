class CreateAdmin < ActiveRecord::Migration[6.0]
  def change
    create_table :admins do |t|
      t.string  :name, limit: 50
      t.string  :password_hash
      t.boolean  :active
      t.timestamps
    end

    add_index :admins, :name

    create_table :roles do |t|
      t.string :name
      t.text :description
    end
    add_index :roles, :name

    create_table :role_assignments do |t|
      t.integer :admin_id
      t.integer :role_id
    end
    add_index :role_assignments, :admin_id
    add_index :role_assignments, :role_id
    add_index :role_assignments, [:admin_id, :role_id]
  end
end
