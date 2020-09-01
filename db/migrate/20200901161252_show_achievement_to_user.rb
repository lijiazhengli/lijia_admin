class ShowAchievementToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :show_achievement, :boolean, default: false
  end
end
