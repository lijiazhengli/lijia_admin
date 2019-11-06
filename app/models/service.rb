class Service < Product
  scope :applet_home, -> {where(active: true).order(:position)}

  def to_applet_list
    {
      title: self.title,
      id: self.id,
      desc: self.description,
      img_url: self.front_image
    }
  end
end
