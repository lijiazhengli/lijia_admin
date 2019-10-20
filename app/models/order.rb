class Order < ApplicationRecord
  has_many  :order_payment_records
  accepts_nested_attributes_for :order_payment_records, allow_destroy: true

  has_many  :order_arranger_assignments
  has_many  :order_arrangers, through: :city_product_set_offering

  has_many :purchased_items
  accepts_nested_attributes_for :purchased_items, allow_destroy: true

  ORDER_TYPE = {
    'Service'       => '整理服务',
    'Course'       => '课程培训',
    'Product'       => '收纳功能'
  }

  STATUS = {
    'unpaid'       => '待支付',
    'paided'       => '已支付',
    'completed'    => '已完成',
    'canceled'     => '已取消'
  }
end
