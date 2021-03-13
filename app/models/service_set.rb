class ServiceSet < ProductSet
  has_many :services, :class_name => "Service", foreign_key: :product_set_id

  def applet_url
    "/pages/service_sets/show?id=#{self.id}"
  end
end