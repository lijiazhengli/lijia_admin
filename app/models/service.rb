class Service < Product
  scope :applet_home, -> {where(active: true).order(:position)}

  def to_applet_list
    attrs = {
      title: self.title,
      id: self.id,
      desc: self.description,
      count_string: self.count_string,
      price: self.price,
      img_url: self.front_image
    }

    attrs[:start_time] = self.start_time.strftime('%Y/%m/%d %T') if self.start_time.present?
    attrs[:end_time] = self.end_time.strftime('%Y/%m/%d %T') if self.end_time.present?
    attrs

  end

  def show_count_string
    return self.count_string if self.count_string.present?
    '999次'
  end
end
