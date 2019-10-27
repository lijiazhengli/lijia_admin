class Course < Product
  has_many  :students
  accepts_nested_attributes_for :students, allow_destroy: true
  has_many  :course_teachers
  has_many  :teachers, through: :course_teachers
end
