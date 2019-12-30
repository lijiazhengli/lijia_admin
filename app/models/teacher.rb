class Teacher < ApplicationRecord
  scope :applet_home, -> {where(active: true).order(:position)}

  def to_applet_list
    {
      id: self.id,
      name: self.name,
      tag: self.tag,
      desc: self.introduce,
      img_url: self.mobile_image
    }
  end

  def to_course_list
    {
      id: self.id,
      name: self.name,
      tag: self.tag,
      img_url: self.mobile_image
    }
  end
  class << self
    def current_teacher_hash
      Teacher.where(active: true).pluck(:id, :name).to_h
    end
  end
end
