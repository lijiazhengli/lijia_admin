class Product < ActiveRecord::Base
  scope :active, -> { where(active: true) }

  def to_applet_show
    {
      id: self.id,
      title: self.title,
      desc: self.description,
      price: self.price,
      city_name: self.city_name,
      start_date: self.start_date,
      end_date: self.end_date,
      img_url: self.detailed_image
    }
  end

  def to_applet_list
    {
      id: self.id,
      title: self.title,
      price: self.price,
      img_url: self.front_image
    }
  end
end