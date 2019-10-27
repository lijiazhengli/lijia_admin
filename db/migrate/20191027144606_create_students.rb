class CreateStudents < ActiveRecord::Migration[6.0]
  def change
    create_table :students do |t|
      t.integer :user_id
      t.integer :course_id
      t.integer :order_id
      t.string :city_name
      t.string :careers
      t.string :career_plan
      t.text    :notes
      t.text :feedback
      t.text :review
      t.boolean :active
      t.timestamps
    end

    add_index :students, :user_id
    add_index :students, :course_id
    add_index :students, :order_id
  end
end
