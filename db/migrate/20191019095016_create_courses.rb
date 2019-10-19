class CreateCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string  :title
      t.string  :city_id
      t.string  :city_name
      t.string  :start_date
      t.string  :end_date
      t.text  :description
      t.string  :front_image
      t.string  :detailed_image
      t.boolean  :active
      t.timestamps
    end
  end
end
