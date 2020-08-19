class CourseCityInfo < ApplicationRecord
  scope :active, -> { where(active: true).order(:position) }
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

  def enable
    self.update(active: true)
  end

  def disable
    self.update(active: false)
  end
end
