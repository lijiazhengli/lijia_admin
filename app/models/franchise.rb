class Franchise < ApplicationRecord
  has_many :franchise_images
  scope :available, -> { where(status: ['unconfirmed', 'confirming', 'completed']) }
  scope :inavailable, -> { where(status: ['canceled']) }
  scope :applet_home, -> {where(active: true).order(:position)}

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

  def to_applet_list
    {
      id: self.id,
      title: self.title,
      city_name: self.city_name,
      desc: self.desc,
      img_url: self.front_image
    }
  end

  def to_order_list
    {
      id: self.id,
      city_name: self.city_name,
      user_name: self.user_name,
      phone_number: self.phone_number,
      email: self.email,
      status: self.status,
      apply_msg: self.apply_msg,
      created_at: self.created_at
    }
  end

  def to_applet_show
    attrs = {
      id: self.id,
      title: self.title,
      desc: self.desc,
      city_name: self.city_name,
      img_url: self.detailed_image
    }
    attrs[:desc_images] = self.franchise_images.active.pluck(:mobile_image)
    attrs
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

    def cancel_apply_for_applet(item)
      begin
        item.update!(status: 'canceled')
        return [item, true, nil]
      rescue Exception => e
        return [nil, false, '取消失败，请联系客服']
      end
    end
  end
end
