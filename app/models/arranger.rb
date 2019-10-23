class Arranger < ApplicationRecord
  has_many  :order_arranger_assignments
  has_many  :orders, through: :order_arranger_assignments

end