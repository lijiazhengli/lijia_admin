class Arranger < ApplicationRecord
  has_many  :order_arranger_assignments
  has_many  :orders, through: :order_arranger_assignments
  before_create :init_orders_count

  def init_orders_count
    self.orders_count = self.base_order_count if self.base_order_count > 0
  end
  
  class << self
    def current_arranger_hash
      Arranger.where(active: true).order('orders_count desc, id').select(:id, :name, :orders_count).map{|i| [i.id, "#{i.name}-#{i.orders_count}"]}.to_h
    end
  end

end