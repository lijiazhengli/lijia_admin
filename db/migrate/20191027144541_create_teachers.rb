class CreateTeachers < ActiveRecord::Migration[6.0]
  def change
    create_table :teachers do |t|
      t.string :name
      t.text    :introduce
      t.boolean :active
      t.timestamps
    end

    create_table :course_teachers do |t|
      t.integer :course_id
      t.integer :teacher_id
      t.text    :introduce
      t.timestamps
    end

    add_index :course_teachers, :course_id
    add_index :course_teachers, :teacher_id
  end
end
