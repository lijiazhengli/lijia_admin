class CourseTeacher < ActiveRecord::Base
  audited
  belongs_to :course
  belongs_to :teacher
end