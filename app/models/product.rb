class Product < ActiveRecord::Base
  has_many :product_images
  scope :active, -> { where(active: true) }

  GOOD_TYPE = {
    'Service'    => '整理服务',
    'Course'     => '课程培训',
    'Good'       => '收纳工具'
  }


  def up_serial(target_id)
    self.class.transaction do
      pre_image = self.class.find(target_id)
      index = pre_image.position
      self.class.where.not(id: self.id).where('`position` <= ? AND `position` >= ?', self.position, pre_image.position).update_all('`position` = `position` + 1')
      self.update(:position => index)
    end
  end

  def down_serial(target_id)
    self.class.transaction do
      next_image = self.class.find(target_id)
      index = next_image.position
      self.class.where.not(id: self.id).where('`position` >= ? AND `position` <= ?', self.position, next_image.position).update_all('`position` = `position` - 1')
      self.update(:position => index)
    end
  end

  def enable
    self.update(active: true)
  end

  def disable
    self.update(active: false)
  end


  def self.get_purchased_items(order_type)
    current_type =  order_type == Order::PRODUCT_ORDER ? 'Good' : order_type
    if order_type == 'Course'
      Product.where(type: current_type).map{|i| ["#{i.title}-#{i.price}", i.id]}
    else
      Product.active.where(type: current_type).map{|i| ["#{i.title}-#{i.price}", i.id]}
    end
  end

  def available_order_count
    Order.available.includes(:purchased_items).where(purchased_items: {product_id: self.id}).sum(:quantity)
  end

  def to_applet_show
    attrs = {
      id: self.id,
      title: self.title,
      min_count: self.min_count,
      max_count: self.max_count,
      desc: self.description,
      price: self.price,
      earnest_price: self.earnest_price,
      city_name: self.city_name,
      start_date: self.start_date,
      end_date: self.end_date,
      img_url: self.detailed_image
    }
    if self.type == 'Course'
      info_extend = CourseExtend.find_by_course_id(self.id)
      attrs[:address] = info_extend.try(:address)
      if info_extend.present? and info_extend.show_city_list
        city_infos_list = info_extend.city_infos_list
        if city_infos_list.present?
          course_city_infos = {}
          course_city_infos[:show_city_list] = info_extend.show_city_list
          course_city_infos[:city_infos_list] = city_infos_list
          course_city_infos[:cities] = city_infos_list.keys
          current_city_name = self.city_name.present?  ?  self.city_name : course_city_infos[:cities][0]
          course_city_infos[:course_city] = current_city_name
          course_city_infos[:course_date] = city_infos_list[current_city_name][0]
          course_city_infos[:city_address_infos] = info_extend.city_address_info_list
          attrs[:course_city_infos] = course_city_infos

        end
      end
      attrs[:teachers] = self.teachers.map{|item| item.to_course_list}
      attrs[:order_count] = self.available_order_count
      attrs[:other_courses] = Course.get_recommend_infos(self.id)
      attrs[:other_course_cities] = Course.get_recommend_infos(self.id).keys
      attrs[:other_course_cities] = [self.city_name] + (attrs[:other_course_cities] - [self.city_name]) if attrs[:other_courses][self.city_name]
    end

    attrs[:exprie_product] = true unless self.active
    attrs[:product_images] = self.product_images.active.pluck(:mobile_image)
    attrs
  end

  def to_applet_cart_show
    attrs = {
      id: self.id,
      title: self.title,
      price: self.price,
      earnest_price: self.earnest_price,
      min_count: self.min_count,
      img_url: self.front_image,
      advance_days: self.advance_days
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
      min_count: self.min_count,
      img_url: self.front_image,
      advance_days: self.advance_days
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