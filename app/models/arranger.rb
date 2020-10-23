class Arranger < ApplicationRecord
  has_many  :order_arranger_assignments
  has_many  :orders, through: :order_arranger_assignments
  before_create :init_orders_count
  before_save :update_orders_count, :if => Proc.new{|u| u.base_order_count_changed?}

  def init_orders_count
    self.orders_count = self.base_order_count if self.base_order_count > 0
  end


  def update_orders_count
    current_orders_count = OrderArrangerAssignment.where(arranger_id: self.id, order_type: Order::SERVICE_ORDER).select('distinct order_id').count
    self.orders_count = self.base_order_count + current_orders_count
  end
  
  class << self
    def current_arranger_hash
      Arranger.where(active: true).order('orders_count desc, id').select(:id, :name, :orders_count).map{|i| [i.id, "#{i.name}-#{i.orders_count}"]}.to_h
    end
  end

end