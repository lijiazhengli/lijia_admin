class CreateCourseExtends < ActiveRecord::Migration[6.0]
  def change
    create_table :course_extends do |t|
      t.integer :course_id
      t.string  :address
      t.decimal  :gaode_lng, precision: 11, scale: 8
      t.decimal  :gaode_lat, precision: 11, scale: 8
    end
    add_index :course_extends, :course_id
  end
end
