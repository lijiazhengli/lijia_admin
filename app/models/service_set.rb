class ServiceSet < ProductSet
  has_many :services, :class_name => "Service", foreign_key: :product_set_id
end