class DeliveryOrder < ApplicationRecord
  belongs_to :order
  has_many :purchased_items

  scope :noncanceled, -> { where.not(status: ['canceled']) }

  STATUS = {
    'on_the_road'    => '已发货',
    "delivered"    => '已送到',
    'canceled'     => '已取消'
  }


  def to_applet_list
    {
      express_name: self.express_name,
      express_no: self.express_no,
      purchased_items: self.purchased_items.map{|item| item.to_quantity_order_list}
    }
  end
end
