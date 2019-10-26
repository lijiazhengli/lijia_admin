class Order < ApplicationRecord
  has_many  :order_payment_records
  accepts_nested_attributes_for :order_payment_records, allow_destroy: true

  has_many  :order_arranger_assignments
  has_many  :arrangers, through: :order_arranger_assignments

  has_many :purchased_items
  accepts_nested_attributes_for :purchased_items, allow_destroy: true

  ORDER_TYPE = {
    'Service'       => '整理服务',
    'Course'       => '课程培训',
    'Product'       => '收纳功能'
  }

  SERVICE_ORDER = 'Service'

  STATUS = {
    'unpaid'       => '待支付',
    'paided'       => '已支付',
    'completed'    => '已完成',
    'canceled'     => '已取消'
  }


  def save_with_new_external_id
    start = self.start_date.split('-').join('')
    prefix = self.order_type[0] + 'O'
    max_id = ExternalId.where(prefix: prefix, date: start).first_or_create
    result = nil
    max_id.with_lock do
      new_num = max_id.number + 1
      self.external_id = prefix + start + sprintf('%04d', new_num)
      result = self.save!
      if result
        max_id.update(number: new_num)
      end
    end
    result
  end
end
