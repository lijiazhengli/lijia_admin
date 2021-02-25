# is_course_discount：是否享受课程优惠
class User < ApplicationRecord
  audited
  has_many  :orders
  has_many  :applies
  has_many  :franchises

  COURSE_STUDENT_ZHEKOU = 0.8
  PARTNER_ZHEKOU = 0.6
  ZHEKOU = {1 => '普通客人', 0.8 => '学员', 0.6 => '合伙人'}
  STATUS = {1 => '普通客人', 2 => '学员', 3 => '城市合伙人', 4 => '事业合伙人', 5 => '战略合伙人'}
  AREA_STATUS = {1 => '山东东北大区', 2 => '华北大区', 3 => '华东大区', 4 => '华中大区', 5 => '华南大区', 6 => '西部大区'}


  def get_applet_sex
    self.sex ? "#{self.sex}" : '0'
  end

  def show_name_info
    [self.name, self.phone_number].join(' ')
  end


  def show_status
    STATUS[self.status]
  end

  def to_applet_list
    attrs = {}
    %w(name profession avatar address_province address_city address_district zhekou is_course_discount).each do |info|
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
    attrs[:show_achievement] = true if self.show_achievement
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

  def to_applet_user_order_list(params)
    info = {}
    params[:start_at] = (Time.now - 30.days).strftime('%F') if params[:start_at].blank?
    params[:end_at] = Time.now.strftime('%F') if params[:end_at].blank?
    st = Time.parse(params[:start_at]).beginning_of_day
    et = Time.parse(params[:end_at]).end_of_day
    user_orders = Order.noncanceled.includes(:purchased_items).where(user_id: self.id).where("orders.created_at between ? and ? ", st, et).order('id desc')
    info[:user_orders] = user_orders.map{|o| o.to_user_achievement}
    referral_orders = Order.noncanceled.includes(:purchased_items).where(referral_phone_number: self.phone_number).where("orders.created_at between ? and ? ", st, et).order('id desc')
    info[:referral_orders] = referral_orders.map{|o| o.to_user_achievement}
    organizer_orders = Order.noncanceled.includes(:purchased_items).where(organizer_phone_number: self.phone_number).where("orders.created_at between ? and ? ", st, et).order('id desc')
    info[:organizer_orders] = organizer_orders.map{|o| o.to_user_achievement}
    info[:applied_order_ids] = ApplyItem.noncanceled.where(item_type: "Order", item_id: organizer_orders.map(&:id)).pluck(:item_id)
    user_ids = ([self.id] + referral_orders.map(&:user_id) + organizer_orders.map(&:user_id)).uniq
    order_ids = (user_orders.map(&:id) + referral_orders.map(&:id) + organizer_orders.map(&:id)).uniq
    info[:productInfos] = Product.where(id: PurchasedItem.where(order_id: order_ids).pluck(:product_id)).pluck(:id, :title).to_h
    info[:userInfos] = User.where(id: user_ids).map{|u| [u.id, u.show_name_info]}.to_h
    info[:start_at] = params[:start_at]
    info[:end_at] = params[:end_at]

    return info
  end

  def to_applet_user_apply_fee_order_list(params)
    info = {}
    user = User.where(phone_number: self.phone_number).first
    applied_order_ids = user.applies.order_fee_list.includes(:apply_items).pluck('apply_items.item_id').uniq
    user_orders = Order.paided.includes(:purchased_items).where(organizer_phone_number: self.phone_number).where.not(id: applied_order_ids)
    info[:user_orders] = user_orders.map{|o| o.to_user_achievement}
    info[:total_fee] = Order.user_orders_achievement(user_orders)
    user_ids = user_orders.map(&:user_id).uniq
    order_ids = user_orders.map(&:id).uniq
    info[:productInfos] = Product.where(id: PurchasedItem.where(order_id: order_ids).pluck(:product_id)).pluck(:id, :title).to_h
    info[:userInfos] = User.where(id: user_ids).map{|u| [u.id, u.show_name_info]}.to_h
    return info
  end

end