class OrderArrangerAssignment < ActiveRecord::Base
  belongs_to :order
  belongs_to :arranger

  ITEM_TYPE = {"type_1" => '组长', "type_2" => '副组长', "type_3" => '成员'}
end
