class AddCityAndDateToCourseExtend < ActiveRecord::Migration[6.0]
  def change
  	add_column :course_extends, :city_and_date, :text
  	add_column :course_extends, :show_city_list, :boolean, default: false
  end
end
