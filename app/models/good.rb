class Good < Product
  include LijiaLocal
  belongs_to :good_set, optional: true, foreign_key: :product_set_id, class_name: "GoodSet"
  scope :applet_home, -> {where(active: true).order(:position)}

  def to_applet_list
    {
      id: self.id,
      title: self.title,
      min_count: self.min_count,
      price: self.price,
      img_url: change_to_qiniu_https_url(self.front_image)
    }
  end

  def to_applet_list_v2
    {
      id: self.id,
      title: self.title,
      min_count: self.min_count,
      price: self.price,
      size: self.size,
      detail_img_url: change_to_qiniu_https_url(self.detailed_image),
      img_url: change_to_qiniu_https_url(self.front_image)
    }
  end
end