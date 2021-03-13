class CreateCustomLocks < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_locks do |t|
      t.string   :name
      t.datetime :expire_at
      t.timestamps
    end

    add_index :custom_locks, :name
  end
end
