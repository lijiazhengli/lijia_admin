class PurchasedItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  def to_quantity_order_list
    {
      product_id: self.product_id,
      price: self.price,
      quantity: self.quantity
    }
  end
end