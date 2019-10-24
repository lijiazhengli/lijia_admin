class OrderArrangerAssignment < ActiveRecord::Base
  belongs_to :order
  belongs_to :arranger
  after_create :plus_arranger_order_count, :if => Proc.new{|i| i.order_type == Order::SERVICE_ORDER }
  after_destroy :minus_arranger_order_count, :if => Proc.new{|i| i.order_type == Order::SERVICE_ORDER }

  ITEM_TYPE = {"type_1" => '组长', "type_2" => '副组长', "type_3" => '成员'}

  def plus_arranger_order_count
  	arranger = self.arranger
  	arranger.update_attributes(order_count: arranger.order_count + 1)
  end

  def minus_arranger_order_count
  	arranger = self.arranger
  	arranger.update_attributes(order_count: arranger.order_count - 1)
  end
end
