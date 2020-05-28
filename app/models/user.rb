class User < ApplicationRecord
  has_many  :orders
  has_many  :franchises

  COURSE_STUDENT_ZHEKOU = 0.8
  PARTNER_ZHEKOU = 0.6
  ZHEKOU = {1 => '普通客人', 0.8 => '学员', 0.6 => '合伙人'}

  def get_applet_sex
    self.sex ? "#{self.sex}" : '0'
  end

  def to_applet_list
    attrs = {}
    %w(name profession avatar address_province address_city address_district zhekou).each do |info|
      attrs[info.to_sym] =  self.send(info)
    end
    attrs[:sex] = self.get_applet_sex
    attrs
  end

  def to_applet_crm_list
    attrs = {}
    %w(name avatar zhekou).each do |info|
      attrs[info.to_sym] =  self.send(info)
    end
    attrs[:sex] = self.get_applet_sex
    orders = self.orders.current_orders.select(:order_type)
    Order::ORDER_TYPE.keys.each{|item| attrs["#{item.downcase}_count".to_sym] = orders.select{|i| i.order_type == item}.size}
    attrs[:franchise_count] = self.franchises.available.count
    attrs
  end

  def self.find_or_create_source_user(mobile, source, user_info)
    user = User.where(phone_number: mobile).first
    return user if user.present?
    user_attr = {phone_number: mobile, source: source }
    [:wx_union_id, :wx_ma_id].each {|v| user_attr[v] = user_info[v] if user_info[v].present?}
    User.create!(user_attr)
  end

end