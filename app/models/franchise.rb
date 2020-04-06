class Franchise < ApplicationRecord
  has_many :franchise_images
  scope :available, -> { where(status: ['unconfirmed', 'confirming', 'completed']) }

  STATUS = {
    'unconfirmed'       => '待确认',
    'confirming'       => '确认中',
    'completed'    => '已完成',
    'canceled'     => '已取消'
  }

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

  class << self
    def create_apply_for_applet(info)
      begin
        apply = Franchise.create(info)
        return [apply, true, nil]
      rescue Exception => e
        return [nil, false, '创建失败']
      end
    end
  end
end
