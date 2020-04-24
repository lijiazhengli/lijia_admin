class AddHasStudentZhekouToCourseExtend < ActiveRecord::Migration[6.0]
  def change
  	add_column :course_extends, :has_student_zhekou, :boolean, default: false
  end
end
