class GoodSet < ProductSet
  has_many :goods, :class_name => "Good", foreign_key: :product_set_id
  def applet_url
    "/pages/good_sets/show?id=#{self.id}"
  end
end