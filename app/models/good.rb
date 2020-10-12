class Good < Product
  scope :applet_home, -> {where(active: true).order(:position)}

  def to_applet_list
    {
      id: self.id,
      title: self.title,
      min_count: self.min_count,
      price: self.price,
      img_url: self.front_image
    }
  end

  def to_applet_list_v2
    {
      id: self.id,
      title: self.title,
      min_count: self.min_count,
      price: self.price,
      size: self.size,
      img_url: self.front_image
    }
  end
end