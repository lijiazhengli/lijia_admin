class DeliveryOrder < ApplicationRecord
	belongs_to :order
	has_many :purchased_items

	STATUS = {
    'on_the_road'    => '已发货',
    "delivered"    => '已送到',
    'canceled'     => '已取消'
  }
end
