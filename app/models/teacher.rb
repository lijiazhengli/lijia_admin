class Teacher < ApplicationRecord
  scope :current_active, -> {where(active: true).order(:position)}

  def up_serial(target_id)
    self.class.transaction do
      pre_image = self.class.find(target_id)
      index = pre_image.position
      self.class.where.not(id: self.id).where('`position` <= ? AND `position` >= ?', self.position, pre_image.position).update_all('`position` = `position` + 1')
      self.update(:position => index)
    end
  end

  def down_serial(target_id)
    self.class.transaction do
      next_image = self.class.find(target_id)
      index = next_image.position
      self.class.where.not(id: self.id).where('`position` >= ? AND `position` <= ?', self.position, next_image.position).update_all('`position` = `position` - 1')
      self.update(:position => index)
    end
  end

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
