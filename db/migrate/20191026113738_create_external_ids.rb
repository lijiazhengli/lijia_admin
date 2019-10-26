class CreateExternalIds < ActiveRecord::Migration[6.0]
  def change
    create_table :external_ids do |t|
      t.string :prefix, limit: 5
      t.string :date
      t.integer :number, default: 0
    end
    add_column :orders, :external_id, :string, limit: 20
    add_column :orders, :notes, :text
    add_column :orders, :service_notes, :text

    add_index :external_ids, [:prefix, :date]
    add_index :orders, :external_id
  end
end
