class ProductSet < ApplicationRecord
  audited
  include LijiaLocal
  has_many :product_set_images
  has_many :products
  scope :active, -> { where(active: true).order(:position) }
  scope :applet_home, -> {where(active: true).order(:position)}

  def to_applet_list
    {
      id: self.id,
      title: self.title,
      img_url: change_to_qiniu_https_url(self.front_image)
    }
  end

  def to_applet_show
    attrs = {
      id: self.id,
      title: self.title,
      desc: self.description,
      img_url: change_to_qiniu_https_url(self.detailed_image)
    }

    attrs[:exprie_product] = true unless self.active
    attrs[:item_images] = self.product_set_images.active.pluck(:mobile_image).map{|i| change_to_qiniu_https_url(i)}
    attrs
  end

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
