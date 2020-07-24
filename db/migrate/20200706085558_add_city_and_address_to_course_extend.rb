class AddCityAndAddressToCourseExtend < ActiveRecord::Migration[6.0]
  def change
  	add_column :course_extends, :city_and_address, :text
  end
end
