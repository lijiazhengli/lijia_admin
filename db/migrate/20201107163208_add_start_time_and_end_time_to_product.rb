class AddStartTimeAndEndTimeToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :start_time, :datetime, default: nil
    add_column :products, :end_time, :datetime, default: nil
  end
end
