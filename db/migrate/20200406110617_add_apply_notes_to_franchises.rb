class AddApplyNotesToFranchises < ActiveRecord::Migration[6.0]
  def change
    add_column :franchises, :apply_msg, :text
    add_column :franchises, :apply_notes, :text
    add_index :franchises, [:user_id, :active]
  end
end
