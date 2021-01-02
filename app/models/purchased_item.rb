class PurchasedItem < ActiveRecord::Base
  audited
  belongs_to :order
  belongs_to :product
  has_one :delivery_order

  def to_quantity_order_list
    {
      product_id: self.product_id,
      price: self.price,
      quantity: self.quantity
    }
  end
end