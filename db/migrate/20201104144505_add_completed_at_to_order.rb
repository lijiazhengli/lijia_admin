class AddCompletedAtToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :completed_at, :string, default: nil
  end
end
