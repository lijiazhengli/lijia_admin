class AppletsController < ApplicationController
  protect_from_forgery

  def index
    request_info = {}
    request_info[:home_slideshows] = AdImage.applet_home.map{|item| item.to_applet_list}
    request_info[:services] = Service.applet_home.limit(4).map{|item| item.to_applet_list}
    request_info[:courses] = Course.applet_home.limit(2).map{|item| item.to_applet_list}
    request_info[:goods] = Good.applet_home.map{|item| item.to_applet_list}
    render json: request_info
  end

  def course_index
    request_info = {}
    request_info[:pages_slideshows] = AdImage.applet_course.map{|item| item.to_applet_list}
    request_info[:courses] = Course.applet_home.map{|item| item.to_applet_list}
    render json: request_info
  end

  def service_index
    request_info = {}
    request_info[:pages_slideshows] = AdImage.applet_service.map{|item| item.to_applet_list}
    request_info[:services] = Service.applet_home.map{|item| item.to_applet_list}
    render json: request_info
  end

  def cart_show
    p params
    product = Product.find(params[:id])
    request_info = {}
    request_info[:info] = product.to_applet_cart_show
    request_info[:cart_info] = product.to_applet_list
    render json: request_info
  end

  def product_show
    p params
    product = Product.find(params[:id])
    request_info = {}
    request_info[:info] = product.to_applet_show
    request_info[:cart_info] = product.to_applet_list
    render json: request_info
  end

  def login
    request = Wx::MiniApplet.get_open_id_by(params[:code])
    #request['session_key']用于 wx.checkSession， 检查登陆是否已过期
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

  def cart
    products = Product.get_product_list_hash(params[:product_ids].split(','))
    render json: {productInfos: products}
  end

  def save_address
    p 'save_address start'
    p params
    user = User.where(phone_number: params[:customer_phone_number]).last
    params[:user_id] = user.try(:id)
    address_attr = address_params

    p address_attr
  
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
    address.errors
    render json: {current_address: address.to_cart_info}
  end


  def load_address_list(current_address = nil)
    user = User.where(phone_number: params[:customer_phone_number]).last
    user_addresses = Address.for_user(user.id).order('id desc')
    address_hash = user_addresses.select{|item| item.gaode_lng.present?}.map{|item| item.to_cart_info}
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
      if params[:status].blank?
        orders = user.orders.includes(:purchased_items).order('orders.id desc')
      else
        orders = user.orders.where(status: params[:status]).includes(:purchased_items).order('orders.id desc')
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


  def cancel_order
    order = Order.find(params[:order_id]) rescue nil
    if order
      order, success, errors = Order.create_or_update_order({order: order, params: params, methods: %w(cancel_order), redis_expire_name: "order-#{order.id}"})
      render json: {success: success, errors: errors.values[0]}
    else
      render json: {success: false, errors: '订单信息错误'}
    end
  end

  def check_order_status
    order = Order.find(params[:order_id]) rescue nil
    if order.blank?
      success = false
      errors = '付款失败，请致电客服热线4008-3-14159'
    else
      success, errors, new_status = order.check_applet_order_status
    end
    if success
      weixin_option = order.weixin_pay_json('127.0.0.1', order.wx_open_id, {appid: ENV['WX_MINIAPPLET_APP_ID'], mch_id: ENV['WX_MCH_ID']})
      if weixin_option.present?
        render json: {success: true, weixin_option: weixin_option}
      else
        render json: {success: false, errors: '付款失败，请致电客服热线4008-3-14159'}
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

  def create_order
    p params
    order_info = params[:orderInfo]
    user = User.where(phone_number: order_info[:customer_phone_number]).last


    order_info[:wx_ma_id] = user.wx_ma_id
    order_attr = base_order_params

    p order_attr
    order_attr.merge!(applet_order_base_info(order_info))

    if order_info[:address_id].present?
      order_attr.merge!(Address.find(order_info[:address_id]).to_applet_order_info)
    end

    order_attr[:user_id] = user.id
    order_attr[:city_name] = order_attr[:address_city]

    order_attr, purchased_items = get_purchased_items(order_attr, params[:cartProducts])

    option = {order_attr: order_attr.permit!, params: order_info}
    option[:purchased_items] = purchased_items
    option[:user] = user if user.present?

    option[:methods] = %w(check_user create_order  save_with_new_external_id)
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


    order_info[:wx_ma_id] = user.wx_ma_id
    order_attr = base_order_params

    p order_attr
    order_attr.merge!(applet_service_base_info(order_info))

    if order_info[:address_id].present?
      order_attr.merge!(Address.find(order_info[:address_id]).to_applet_order_info)
    end

    order_attr[:user_id] = user.id
    order_attr[:city_name] = order_attr[:address_city]
    option = {order_attr: order_attr.permit!, params: order_info}
    option[:purchased_items] = get_service_purchased_items(order_info)
    option[:user] = user if user.present?

    option[:methods] = %w(check_user create_order save_with_new_external_id)
    option[:redis_expire_name] = "applet-#{order_info[:wx_ma_id]}"
    p option
    @order, success, errors = Order.create_or_update_order(option)
    if success
      render json: {success: success, order: @order}
    else
      render json: {success: false, errors: errors.values[0]}
    end
    @order, success, errors = Order.create_or_update_order(option)
  end

  def create_course_order
    p params
    order_info = params
    user = User.where(phone_number: params[:customer_phone_number]).last

    order_info[:wx_ma_id] = user.wx_ma_id
    order_attr = base_course_params
    order_attr.merge!(applet_course_base_info(order_info))

    order_attr[:user_id] = user.id
    order_attr[:city_name] = order_attr[:city_name]

    option = {order_attr: order_attr.permit!, params: order_info}
    option[:purchased_items] = get_course_purchased_items(order_info)
    option[:user] = user if user.present?

    option[:methods] = %w(check_user create_order create_course_student save_with_new_external_id)
    option[:redis_expire_name] = "applet-#{order_info[:wx_ma_id]}"

    p option
    @order, success, errors = Order.create_or_update_order(option)
    if success
      render json: {success: success, order: @order}
    else
      render json: {success: false, errors: errors.values[0]}
    end
  end



  def applet_order_base_info(order_info)
    {
      status: "unpaid",
      wx_open_id: order_info[:wx_ma_id],
      purchase_source: "美莉家小程序",
      order_type: 'Product'
    }
  end

  def applet_service_base_info(order_info)
    info = applet_order_base_info(order_info)
    info[:order_type] = 'Service'
    info
  end

  def applet_course_base_info(order_info)
    info = applet_order_base_info(order_info)
    info[:order_type] = 'Course'
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
    [{product_id: service.id, quantity: order_info[:service_quantity] || 1}]
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
      :city_name,
      :applet_form_id,
      :user_id
    )
  end

end
