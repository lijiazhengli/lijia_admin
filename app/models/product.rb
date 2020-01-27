class Product < ActiveRecord::Base
  scope :active, -> { where(active: true) }

  def self.get_purchased_items(order_type)
    current_type =  order_type == Order::PRODUCT_ORDER ? 'Good' : order_type
    Product.active.where(type: current_type).map{|i| ["#{i.title}-#{i.price}", i.id]}
  end

  def to_applet_show
    attrs = {
      id: self.id,
      title: self.title,
      desc: self.description,
      price: self.price,
      city_name: self.city_name,
      start_date: self.start_date,
      end_date: self.end_date,
      img_url: self.detailed_image
    }
    if self.type == 'Course'
      info_extend = CourseExtend.find_by_course_id(self.id)
      attrs[:address] = info_extend.try(:address)
      attrs[:teachers] = self.teachers.map{|item| item.to_course_list}
    end
    attrs
  end

  def to_applet_cart_show
    attrs = {
      id: self.id,
      title: self.title,
      price: self.price,
      img_url: self.detailed_image
    }
    if self.type == 'Course'
      info_extend = CourseExtend.find_by_course_id(self.id)
      attrs[:address] = info_extend.try(:address)
    end
    attrs
  end

  def to_applet_list
    {
      id: self.id,
      title: self.title,
      price: self.price,
      img_url: self.front_image
    }
  end

  def self.get_product_list_hash(product_ids)
    products =  Product.where(id: product_ids)
    item_hash = {}
    products.each do |product|
      item_hash[product.id] = product.to_applet_list
    end
    return item_hash
  end
end