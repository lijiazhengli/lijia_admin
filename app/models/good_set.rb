class GoodSet < ProductSet
  has_many :goods, :class_name => "Good", foreign_key: :product_set_id
end