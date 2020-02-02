class ProductImage < ApplicationRecord
  belongs_to :product
  scope :active, -> { where(active: true).order(:position) }

   def up_serial(target_id)
    self.class.transaction do
      pre_image = ProductImage.find(target_id)
      index = pre_image.position
      ProductImage.where(product_id: self.product_id).where.not(id: self.id).where('`position` <= ? AND `position` >= ?', self.position, pre_image.position).update_all('`position` = `position` + 1')
      self.update(:position => index)
    end
  end

  def down_serial(target_id)
    self.class.transaction do
      next_image = ProductImage.find(target_id)
      index = next_image.position
      ProductImage.where(product_id: self.product_id).where.not(id: self.id).where('`position` >= ? AND `position` <= ?', self.position, next_image.position).update_all('`position` = `position` - 1')
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
