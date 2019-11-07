class Course < Product
  has_many  :students
  accepts_nested_attributes_for :students, allow_destroy: true
  has_many  :course_teachers
  has_many  :teachers, through: :course_teachers

  scope :applet_home, -> {where(active: true).order(:position)}

  def to_applet_list
    {
      id: self.id,
      title: self.title,
      desc: self.description,
      price: self.price,
      city_name: self.city_name,
      start_date: self.start_date,
      end_date: self.end_date,
      img_url: self.front_image
    }
  end
end