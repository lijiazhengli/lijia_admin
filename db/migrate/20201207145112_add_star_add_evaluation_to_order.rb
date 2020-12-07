class AddStarAddEvaluationToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :star, :float, default: nil
    add_column :orders, :evaluation, :text, default: nil
  end
end
