class AppletsController < ApplicationController
  protect_from_forgery

  def login
    request = Wx::MiniApplet.get_open_id_by(params[:code])
    #request['session_key']用于 wx.checkSession， 检查登陆是否已过期
    Rails.logger.info "----#{Time.now.strftime("%F %T")}-----update_product_logger_params: #{request.inspect}"
    user_info = {}
    if request['openid'].present?
      user = User.find_by_wx_ma_id(request['openid'])
      user = User.find_by_wx_union_id(request['unionid']) if user.blank? and request['unionid'].present?
      user_info.merge!(wx_union_id: request['unionid'], customerPhoneNumber: user.phone_number) if user.present?
      if user.blank?
        phone_number = Wx::MiniApplet.decryptData(request['session_key'], params)
        if phone_number.present?
          user = User.find_or_create_source_user(phone_number, 'weixin_applet', {wx_ma_id: request['openid']})
          user.update(wx_ma_id: request['openid']) if user.wx_ma_id.blank?
          user_info.merge!(customerPhoneNumber: user.phone_number) 
        end
      end
      user_info.merge!(wx_mp_id: request['openid'])
      user_info.merge!(wx_union_id: request['unionid']) if request['unionid'].present?
    end
    render json: user_info
  end

  def index
    request_info = {}
    request_info[:pages_slideshows] = AdImage.applet_home.map{|item| item.to_applet_list}
    request_info[:services] = Service.applet_home.map{|item| item.to_applet_list}
    request_info[:courses] = Course.applet_home.map{|item| item.to_applet_list}
    request_info[:goods] = Good.applet_home.map{|item| item.to_applet_list}
    request_info[:product_sets] = ProductSet.applet_home.map{|item| item.to_applet_list}
    render json: request_info
  end

  def franchise_index
    request_info = {}
    request_info[:pages_slideshows] = []
    request_info[:franchises] = Franchise.applet_home.map{|item| item.to_applet_list}
    render json: request_info
  end

  def course_index
    request_info = {}
    request_info[:pages_slideshows] = AdImage.applet_course.map{|item| item.to_applet_list}
    request_info[:courses] = Course.applet_home.map{|item| item.to_applet_list}
    render json: request_info
  end

  def good_index
    request_info = {}
    request_info[:pages_slideshows] = AdImage.applet_good.map{|item| item.to_applet_list}
    request_info[:goods] = Good.applet_home.map{|item| item.to_applet_list}
    render json: request_info
  end

  def product_set_index
    request_info = {}
    request_info[:pages_slideshows] = AdImage.applet_good.map{|item| item.to_applet_list}
    request_info[:product_sets] = ProductSet.applet_home.map{|item| item.to_applet_list}
    render json: request_info
  end

  def franchise_show
    item = Franchise.find(params[:id])
    request_info = {}
    request_info[:info] = item.to_applet_show
    render json: request_info
  end

  def home_show
    request_info = {}
    request_info[:home_introduces] = Introduce.applet_home.map{|item| item.to_applet_list}
    request_info[:team_introduces] = Introduce.active_team.map{|item| item.to_applet_list}
    request_info[:teacher_introduces] = Teacher.current_active.map{|item| item.to_applet_list}
    request_info[:franchise_introduces] = Introduce.applet_franchise.limit(1).map{|item| item.to_applet_list}
    render json: request_info
  end


  def service_index
    request_info = {}
    request_info[:pages_slideshows] = AdImage.applet_service.map{|item| item.to_applet_list}
    request_info[:services] = Service.applet_home.map{|item| item.to_applet_list}
    render json: request_info
  end

  def load_product_infos
    products = []
    product_info = (JSON.parse(params[:product_info]) || {})
    product_ids = product_info.keys
    Product.where(id: product_ids).each do |product|
      info = product.to_applet_list
      info[:quantity] = product_info[product.id.to_s] || info[:min_count] || 1
      products << info
    end
    render json: {products: products}
  end

  def cart_show
    product = Product.find(params[:id])
    order_start_delivery_time = Time.now
    order_start_delivery_time = order_start_delivery_time + 1.days if order_start_delivery_time.hour >= 18
    order_end_delivery_time = order_start_delivery_time + 30.days
    request_info = {
      info: product.to_applet_cart_show,
      cart_info: product.to_applet_list,
      orderStartTime: (order_start_delivery_time-1.hours).strftime("%Y/%m/%d %T"),
      minValidDate: order_start_delivery_time.strftime("%F"),
      maxValidDate: order_end_delivery_time.strftime("%F"),
      unSelectDates: [],
    }
    render json: request_info
  end

  def cart_base_show
    request_info = {
      undelivery_info: {
        inprovince_names: QUANGUO_PRODUCT_INDELIVERY_PROVINCE_NAME,
        incity_names: QUANGUO_PRODUCT_INDELIVERY_CITY_NAME,
        inarea_names: QUANGUO_PRODUCT_INDELIVERY_AREA_NAME
      }
    }
    render json: request_info
  end

  def product_show
    product = Product.find(params[:id]) rescue nil
    product = Product.active.first if product.blank?
    request_info = {}
    request_info[:info] = product.to_applet_show
    request_info[:cart_info] = product.to_applet_list
    p request_info
    render json: request_info
  end

  def product_set_show
    set = ProductSet.find(params[:id]) rescue nil
    set = ProductSet.active.first if set.blank?
    request_info = {}
    request_info[:info] = set.to_applet_show
    request_info[:product_info] = set.products.active.map{|i| i.to_applet_list_v2}
    render json: request_info
  end

   def order_show
    p params
    delivery_orders = []
    if params[:id].present?
      order = Order.find(params[:id])
      delivery_orders = order.delivery_orders.noncanceled.includes(:purchased_items).map{|d| d.to_applet_list}
      order_product_ids = order.purchased_items.pluck(:product_id)
    end
    products = Product.get_product_list_hash(order_product_ids.uniq)
    if order.present?
      render json: {order: order, products: products, delivery_orders: delivery_orders}
    else
      render json: {emptyPageNotice: '暂无订单'}
    end
  end

  def order_payment_show
    p params
    delivery_orders = []
    if params[:id].present?
      order = Order.find(params[:id])
      order_product_ids = order.purchased_items.pluck(:product_id)
    end
    products = Product.get_product_list_hash(order_product_ids.uniq)
    if order.present?
      render json: {order: order, products: products, purchased_items: order.purchased_items, order_payment_records: order.order_payment_records, paymentMenthods: OrderPaymentRecord::APPLET_SELECT_PAYMENT_METHOD_ID}
    else
      render json: {emptyPageNotice: '暂无订单'}
    end
  end

  def create_order_payment
    user = User.where(phone_number: params[:customer_phone_number]).last
    order = Order.find(params[:order_id])
    record_info = order_payment_params
    record_info[:operate_user_id] = user.id
    record_info[:payment_method_id] = OrderPaymentRecord::PAYMENT_METHOD_ID.invert[params[:payment_method_name]]
    order.order_payment_records.create(record_info)
    render json: {success: true, order_payment_records: order.order_payment_records}
  end

  def delete_order_payment
    user = User.where(phone_number: params[:customer_phone_number]).last
    payment = OrderPaymentRecord.find(params[:id])
    if user.id == payment.try(:operate_user_id)
      order_id = payment.order_id
      payment.destroy
      render json: {success: true, order_payment_records: OrderPaymentRecord.where(order_id: order_id)}
    else
      render json: {success: true, errors: '付款信息不正确'}
    end
  end

  def user_info
    p params
    user = User.where(phone_number: params[:customer_phone_number]).last    
    render json: {userInfo: user.to_applet_list}
  end

  def crm_info
    p params
    user = User.where(phone_number: params[:customer_phone_number]).last
    render json: {userInfo: user.to_applet_crm_list}
  end

  def apply_fee
    p params
    user = User.where(phone_number: params[:customer_phone_number]).last
    userInfo = user.to_applet_user_apply_fee_order_list(params)
    p userInfo
    
    render json: userInfo
  end

  def user_order
    p params
    user = User.where(phone_number: params[:customer_phone_number]).last
    userInfo = user.to_applet_user_order_list(params)
    p userInfo
    
    render json: userInfo
  end

  def load_customer_info
    user = User.where(phone_number: params[:customer_phone_number]).last
    customer_info = {}
    render json: {userInfo: user.to_applet_list}
  end

  def save_user_info
    user = User.where(phone_number: params[:customer_phone_number]).last
    user.update(user_params)
    render json: {userInfo: user.to_applet_list}
  end

  def cart
    products = Product.get_product_list_hash(params[:product_ids].split(','))
    render json: {productInfos: products}
  end

  def save_address
    user = User.where(phone_number: params[:customer_phone_number]).last
    params[:user_id] = user.try(:id)
    address_attr = address_params
  
    Address.for_user(params[:user_id]).update_all(is_default: false) if address_attr[:is_default] == '1' and params[:user_id].present?

    if params[:address_id].present?
      address = Address.find(params[:address_id]) rescue nil
      if address.present?
        address.update_attributes(address_attr)
      else
        address = Address.create(address_attr)
      end
    else
      address = Address.create(address_attr)
    end
    render json: {current_address: address.to_cart_info}
  end


  def load_address_list(current_address = nil)
    user = User.where(phone_number: params[:customer_phone_number]).last
    user_addresses = Address.for_user(user.id).order('id desc')
    address_hash = user_addresses.map{|item| item.to_cart_info}
    render json: {addresses: address_hash, current_address: current_address || address_hash[0]}
  end

  def load_address_info
    address = Address.find(params[:id]) rescue nil
    render json: {address: address.to_cart_info}
  end

  def delete_user_address
    address = Address.find(params[:id]).destroy rescue nil
    load_address_list
  end


  def orders
    p params
    user = User.where(phone_number: params[:customer_phone_number]).last
    if user.present?
      order_product_ids = []
      order_infos = []
      order_type = params[:order_type] || 'Service'
      if params[:status].blank?
        orders = user.orders.where(order_type: order_type).includes(:purchased_items).order('orders.id desc')
      else
        orders = user.orders.where(order_type: order_type, status: params[:status]).includes(:purchased_items).order('orders.id desc')
      end
      orders.each do |order|
        info, product_ids = order.to_applet_order_list
        order_infos << info
        order_product_ids += product_ids
      end
      products = Product.get_product_list_hash(order_product_ids.uniq)
      attr_info = {orders: order_infos, products: products}
      attr_info[:emptyPageNotice] = '暂无订单' if order_infos.blank?
      render json: attr_info
    else
      render json: {orders: [], products: {}, emptyPageNotice: '暂无订单'}
    end
  end

  def user_franchises
    user = User.where(phone_number: params[:customer_phone_number]).last
    if user.present?
      attr_info = {}
      franchises = user.franchises.available.order('updated_at desc').map{|item| item.to_order_list}
      franchises += user.franchises.inavailable.order('id desc').map{|item| item.to_order_list}
      attr_info[:franchises] = franchises
      attr_info[:emptyPageNotice] = '暂无加盟申请' if franchises.blank?
      render json: attr_info
    else
      render json: {orders: [], products: {}, emptyPageNotice: '暂无加盟申请'}
    end
  end


  def cancel_order
    order = Order.find(params[:order_id]) rescue nil
    if order
      order, success, errors = Order.create_or_update_order({order: order, params: params, methods: %w(cancel_order), redis_expire_name: "order-#{order.id}"})
      render json: {success: success, errors: errors.values[0]}
    else
      render json: {success: false, errors: '订单信息错误'}
    end
  end

  def cancel_franchise
    item = Franchise.find(params[:id]) rescue nil
    if item
      item, success, errors = Franchise.cancel_apply_for_applet(item)
      render json: {success: success, errors: errors}
    else
      render json: {success: false, errors: '加盟申请信息错误'}
    end
  end

  def check_order_status
    order = Order.find(params[:order_id]) rescue nil
    if order.blank?
      success = false
      errors = '付款失败，请访问【我的】联系客服'
    else
      success, errors, new_status = order.check_applet_order_status
    end
    if success
      weixin_option = order.weixin_pay_json('127.0.0.1', order.wx_open_id, {appid: ENV['WX_MINIAPPLET_APP_ID'], mch_id: ENV['WX_MCH_ID']})
      if weixin_option.present?
        render json: {success: true, weixin_option: weixin_option}
      else
        render json: {success: false, errors: '付款失败，请访问【我的】联系客服'}
      end
    else
      render json: {success: success, errors: errors, new_status: new_status}
    end
  end


  def address_params
    params.permit(
      :recipient_name,
      :recipient_phone_number,
      :location_title,
      :location_address,
      :location_details,
      :address_province,
      :address_city,
      :address_district,
      :gaode_lng,
      :gaode_lat,
      :user_id,
      :sex,
      :is_default
    )
  end

  def user_params
    params.permit(
      :name,
      :profession,
      :avatar,
      :address_province,
      :address_city,
      :address_district,
      :sex
    )
  end

  def order_payment_params
    params.permit(
      :payment_method_name,
      :cost,
      :remark
    )
  end

  def create_apply_order
    p params
    user = User.where(phone_number: params[:customer_phone_number]).last
    apply_info = base_apply_params
    apply_info[:user_id] = user.try(:id)
    apply, success, errors = Franchise.create_apply_for_applet(apply_info)
    if success
      render json: {success: true}
    else
      render json: {success: false, errors: '加盟申请创建失败， 请稍后再试'}
    end
  end

  def create_apply_order_fee
    p params
    params[:redis_expire_name] = "order_fee_apply_#{params[:customer_phone_number]}"
    msg = nil #Apply.check_redis_expire_name(params)
    if msg.blank?
      apply, success, msg = Apply.create_order_fee_apply_for_applet(params)
      if success
        render json: {success: true}
      else
        render json: {success: false, errors: msg}
      end
    else
      render json: {success: false, errors: msg}
    end
  end

  def create_order
    p params
    order_info = params[:orderInfo]
    user = User.where(phone_number: order_info[:customer_phone_number]).last


    order_info[:wx_ma_id] = user.wx_ma_id
    order_attr = base_order_params

    p order_attr
    order_attr.merge!(applet_good_base_info(order_info))

    if order_info[:address_id].present?
      order_attr.merge!(Address.find(order_info[:address_id]).to_applet_order_info)
    end

    order_attr[:user_id] = user.id
    order_attr[:city_name] = order_attr[:address_city]

    order_attr, purchased_items = get_purchased_items(order_attr, params[:cartProducts])

    option = {order_attr: order_attr.permit!, params: order_info}
    option[:purchased_items] = purchased_items
    option[:user] = user if user.present?

    option[:methods] = %w(check_user create_order  save_with_new_external_id create_tenpay_order_payment_record)
    option[:redis_expire_name] = "applet-#{order_info[:wx_ma_id]}"

    p option
    @order, success, errors = Order.create_or_update_order(option)
    if success
      weixin_option = @order.weixin_pay_json('127.0.0.1', @order.wx_open_id, {appid: ENV['WX_MINIAPPLET_APP_ID'], mch_id: ENV['WX_MCH_ID']})
      if weixin_option.present?
        render json: {success: true, weixin_option: weixin_option}
      else
        render json: {success: true, errors: '订单创建成功， 前往订单页面继续付款'}
      end
    else
      render json: {success: false, errors: errors.values[0]}
    end
  end

  def create_service_order
    p params
    order_info = params[:orderInfo]
    user = User.where(phone_number: order_info[:customer_phone_number]).last
    service = Service.find(order_info[:service_id])


    order_info[:wx_ma_id] = user.wx_ma_id
    order_attr = base_order_params

    p order_attr
    order_attr.merge!(applet_service_base_info(order_info))

    if order_info[:address_id].present?
      order_attr.merge!(Address.find(order_info[:address_id]).to_applet_order_info)
    end

    order_attr[:user_id] = user.id
    order_attr[:city_name] = order_attr[:address_city]
    order_attr[:start_date] = order_info[:delivery_date]

    p order_attr

    option = {order_attr: order_attr.permit!, params: order_info}
    option[:purchased_items] = get_service_purchased_items(order_info)
    option[:user] = user if user.present?

    if service.create_tenpay
      if service.earnest_price and service.price > service.earnest_price
        option[:methods] = %w(check_user create_order save_with_new_external_id create_earnest_tenpay_order_payment_record)
      else
        option[:methods] = %w(check_user create_order save_with_new_external_id create_tenpay_order_payment_record)
      end
    else
      option[:methods] = %w(check_user create_order save_with_new_external_id)
    end

    option[:redis_expire_name] = "applet-#{order_info[:wx_ma_id]}"
    p option
    @order, success, errors = Order.create_or_update_order(option)
    if success
      render json: {success: success, order: @order}
    else
      render json: {success: false, errors: errors.values[0]}
    end
  end

  def create_course_order
    p params

    order_info = params
    course = Course.find(order_info[:course_id])

    if false and course.max_count.present? and course.available_order_count > course.max_count
      render json: {success: false, errors: '课程已满额， 请选择其他课程报名'}
    else
      user = User.where(phone_number: params[:customer_phone_number]).last

      order_info[:wx_ma_id] = user.wx_ma_id
      order_attr = base_course_params
      order_attr.merge!(applet_course_base_info(order_info))

      order_attr[:user_id] = user.id
      order_attr[:city_name] = order_attr[:city_name]

      option = {order_attr: order_attr.permit!, params: order_info}
      option[:purchased_items] = get_course_purchased_items(order_info)
      option[:user] = user if user.present?

      
      if course.create_tenpay
        if course.earnest_price and course.price > course.earnest_price
          option[:methods] = %w(check_user create_order create_course_student save_with_new_external_id create_earnest_tenpay_order_payment_record)
        else
          option[:methods] = %w(check_user create_order create_course_student save_with_new_external_id create_tenpay_order_payment_record)
        end
      else
        option[:methods] = %w(check_user create_order create_course_student save_with_new_external_id)
      end
      option[:redis_expire_name] = "applet-#{order_info[:wx_ma_id]}"

      p option
      @order, success, errors = Order.create_or_update_order(option)
      if success
        render json: {success: success, order: @order}
      else
        render json: {success: false, errors: errors.values[0]}
      end
    end
  end

  def applet_order_base_info(order_info)
    attrs = {
      status: "unpaid",
      wx_open_id: order_info[:wx_ma_id],
      purchase_source: "美莉家小程序",
      order_type: 'Product'
    }
    if order_info[:referral_phone_number].present?
      referral_user = User.where(phone_number: order_info[:referral_phone_number]).last
      if referral_user.present?
        attrs[:referral_phone_number] = referral_user.try(:phone_number)
        attrs[:referral_name] = referral_user.try(:name)
      elsif order_info[:wx_referral_phone_number].present?
        wx_referral_user = User.where(phone_number: order_info[:wx_referral_phone_number]).last
        if wx_referral_user.present?
          attrs[:referral_phone_number] = wx_referral_user.try(:phone_number)
          attrs[:referral_name] = wx_referral_user.try(:name)
        end
      end
    end
    attrs
  end

  def applet_service_base_info(order_info)
    info = applet_order_base_info(order_info)
    info[:order_type] = 'Service'
    info[:notes] = order_info[:notes]
    info
  end

  def applet_course_base_info(order_info)
    info = applet_order_base_info(order_info)
    info[:address_province] = order_info[:address_province]
    info[:address_city] = order_info[:address_city]
    info[:address_district] = order_info[:address_district]
    info[:order_type] = 'Course'
    info[:city_name] = order_info[:course_city] if order_info[:course_city].present?
    if order_info[:course_date].present?
      course_dates = order_info[:course_date].split('-')
      info[:start_date] = update_date_with_year(course_dates[0])
      info[:end_date] = update_date_with_year(course_dates[1] || course_dates[0])
      info[:start_date] = "#{Time.now.year}-#{info[:start_date][5..-1]}" if info[:start_date] > info[:end_date]
    end
    info
  end

  def update_date_with_year(date)
    t = Time.now
    y_date = "#{t.year}-#{date.gsub('.', '-')}"
    y_date = "#{t.year + 1}-#{date.gsub('.', '-')}" if y_date < t.strftime('%F')
    y_date
  end

  def applet_good_base_info(order_info)
    info = applet_order_base_info(order_info)
    info[:zhekou] = order_info[:zhekou] || 1
    info[:order_type] = 'Product'
    info
  end

  def get_purchased_items(order_attr, cart_products)
    return [order_attr, []] if cart_products.blank?
    items = []
    products_ids = []


    cart_products.each{|item| products_ids.push(item[:id])} 
    product_hash = Product.where(id: products_ids).pluck(:id, :price).to_h

    cart_products.each do |info|
      next if info.blank?
      product_id = info[:id].to_i
      items << {product_id: product_id, quantity: info[:quantity].to_i, price: product_hash[product_id] || 0}
    end
    [order_attr, items]
  end

  def get_service_purchased_items(order_info)
    return [] if order_info[:service_id].blank?
    service = Service.find(order_info[:service_id])
    if service.create_tenpay
      [{product_id: service.id, quantity: order_info[:service_quantity] || 1, price: service.price}]
    else
      [{product_id: service.id, quantity: order_info[:service_quantity] || 1}]
    end
  end

  def get_course_purchased_items(order_info)
    return [] if order_info[:course_id].blank?
    course = Course.find(order_info[:course_id])
    [{product_id: course.id, quantity: order_info[:course_quantity] || 1, price: course.price}]
  end


  def base_order_params
    params.require(:orderInfo).permit(
      :customer_name,
      :customer_phone_number,
      :recipient_name,
      :recipient_phone_number,
      :user_id
    )
  end

  def base_course_params
    params.permit(
      :recipient_name,
      :recipient_phone_number,
      :customer_name,
      :customer_phone_number,
      :referral_name,
      :referral_phone_number,
      :city_name,
      :applet_form_id,
      :user_id
    )
  end

  def base_apply_params
    params.permit(
      :user_name,
      :phone_number,
      :email,
      :city_name,
      :applet_form_id
    )
  end

end
