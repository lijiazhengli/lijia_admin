class Service < Product
  scope :applet_home, -> {where(active: true).order(:position)}

  def to_applet_list
    {
      title: self.title,
      id: self.id,
      desc: self.description,
      count_string: self.count_string,
      img_url: self.front_image
    }
  end
end
