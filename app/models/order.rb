class Order < ApplicationRecord
  has_many  :order_payment_records
  accepts_nested_attributes_for :order_payment_records, allow_destroy: true

  has_many  :order_arranger_assignments
  has_many  :arrangers, through: :order_arranger_assignments

  has_many :purchased_items
  accepts_nested_attributes_for :purchased_items, allow_destroy: true

  scope :current_orders, -> {where(status: CURRENT_STATUS).order('id desc')}

  TENPAY_ID = 2

  ORDER_TYPE = {
    'Service'       => '整理服务',
    'Course'       => '课程培训',
    'Product'       => '收纳工具'
  }

  SERVICE_ORDER = 'Service'
  COURSE_ORDER = 'Course'
  PRODUCT_ORDER = 'Product'

  STATUS = {
    'unpaid'       => '待支付',
    'part-paid'    => '部分付款',
    'paided'       => '已支付',
    'on_the_road'    => '已发货',
    'completed'    => '已完成',
    'canceled'     => '已取消'
  }

  CURRENT_STATUS = %w(unpaid paided part-paid)

  def to_applet_order_list
    attrs = self.attributes.slice(
      "address_province", "address_city", "address_district", 'created_at',
      "id", "location_title",
      'order_type', "recipient_name", "recipient_phone_number", "status",
      "wx_open_id", 
    )
    attrs["purchased_items"] = self.purchased_items.map{|item| item.to_quantity_order_list}
    attrs["order_total_fee"] = self.order_total_fee
    attrs["no_payed_due"] = self.no_paid_due
    attrs["tenpay_payed_due"] = self.no_tenpay_paid_due
    attrs["product_counts"] = self.purchased_items.sum(:quantity)
    product_ids = self.purchased_items.pluck(:product_id).uniq
    [attrs, product_ids]
  end

  def check_applet_order_status
    return [false, "订单已经完成付款，请勿重复付款", 'paided'] if self.status == 'paided' or self.no_paid_due <= 0
    return [false, "抱歉您的订单已失效，如需购买请重新下单", 'canceled'] if self.status == 'canceled'
    return [false, "付款失败，如需帮助请联系客服", nil] if self.status != 'unpaid'
    return [true, nil, nil]
  end


  def save_with_new_external_id
    start = self.start_date.split('-').join('')
    prefix = self.order_type[0] + 'O'
    max_id = ExternalId.where(prefix: prefix, date: start).first_or_create
    result = nil
    max_id.with_lock do
      new_num = max_id.number + 1
      self.external_id = prefix + start + sprintf('%04d', new_num)
      result = self.save!
      if result
        max_id.update(number: new_num)
      end
    end
    result
  end

  def next_payment_method_num(method_id)
    self.external_id + "#{self.order_payment_records.where(payment_method_id: method_id).count+1}"
  end


  def no_paid_due
    total_cost = self.order_payment_records.unpaid.sum(:cost).round(2)
    total_cost
  end

  def no_tenpay_paid_due
    total_cost = self.order_payment_records.tenpay_method.unpaid.sum(:cost).round(2)
    total_cost
  end

  def order_total_fee
    total_cost = self.order_payment_records.sum(:cost).round(2)
    total_cost
  end

  def order_paid_due
    total_cost = self.order_payment_records.paid.sum(:cost).round(2)
    total_cost
  end

  def total_unpaid_fee
    product_cost = self.purchased_items.sum('price * quantity')
    paid_due = self.order_payed_due
    (product_cost-paid_due).round(2)
  end

  def order_transfer_info(method_id)
    item = self.order_payment_records.where(payment_method_id: method_id).unpaid.last
    return [nil,nil] if item.blank?
    [item.out_trade_no, item.cost]
  end

  def weixin_pay_json(ip, openid, wx_attr = {})
    return {} if openid.blank?
    trade_no, trade_due = self.order_transfer_info(Order::TENPAY_ID)
    params = {
      body: "美莉家-微信支付",
      out_trade_no: trade_no,
      total_fee: String(Integer(trade_due * 100)),
      spbill_create_ip: "#{ip}",
      notify_url: ENV['WX_PAYMENT_NOTIFICATION_URL'],
      trade_type: 'JSAPI',
      openid: openid
      }
    r = WxPay::Service.invoke_unifiedorder params, wx_attr
    p r
    if r.success?
      option = {
        appId: r['appid'],
        package: "prepay_id=#{r['prepay_id']}",
        nonceStr: r['nonce_str'],
        timeStamp: "#{Time.now.to_i}",
        signType: "MD5"
      }
      str = "appId=#{option[:appId]}&nonceStr=#{option[:nonceStr]}&package=#{option[:package]}&signType=#{option[:signType]}&timeStamp=#{option[:timeStamp]}&key=#{ENV['WX_MCH_KEY']}"
      pay_sign = Digest::MD5.hexdigest(str).upcase
      option[:paySign] = pay_sign
    else
      option = {}
    end
    option
  end

  class << self
    @@order_logger = Logger.new 'log/order_logger.log'
    def generate_out_trade_no
      DateTime.now.strftime('%Y%m%d%H%M%S%L')
    end
    def create_or_update_order options= {}
      @@order_logger.info (Time.now.to_s + '......................  CREATE_OR_UPDATE_ORDER_BIGIN............................')
      @@order_logger.info (Time.now.to_s + {'m_name' => 'CREATE_UPDATE_ORDER', 'PARAMS' => options}.to_s)
      success = false
      allow_methods = %w(
        check_user create_order create_course_student save_with_new_external_id update_order cancel_order create_tenpay_order_payment_record update_order_payment_record
      )

      all_methods = options.symbolize_keys![:methods] || []
      select_methods = allow_methods & all_methods

      params = options[:params]
      user = options[:user] || ((User.find(options[:user_id].to_i) rescue nil) if options[:user_id].present?)
      order_hash = {
        redis_expire_name: options[:redis_expire_name],
        order: options[:order],
        user: options[:user],
        order_attr: options[:order_attr] || {},
        purchased_items: options[:purchased_items] || [],
        current_payment_record: options[:current_payment_record],
        errors: {}
      }
      @@order_logger.info (Time.now.to_s + {'m_name' => 'TRANSACTION_METHODS_BIGIN', 'METHODS' => select_methods, 'ORDER_HASH' => order_hash}.to_s)
      begin
        Order.transaction do
          check_redis_expire_name(order_hash, options)
          select_methods.each do |method|
            p method
            send("#{method}", order_hash, params)
          end
          p order_hash
          $redis.del(options[:redis_expire_name]) if options[:redis_expire_name].present?
          success = true
        end

      rescue Exception => exp
        order_hash[:errors][:raise_erro] = exp.message
        $redis.del(options[:redis_expire_name]) if options[:redis_expire_name].present?
      end
      @@order_logger.info (Time.now.to_s + {'m_name' => 'TRANSACTION_METHODS_END', 'METHODS' => select_methods, 'ORDER_HASH' => order_hash}.to_s)
      [order_hash[:order],success,order_hash[:errors]]
    end

    def check_redis_expire_name(order_hash, params)
      redis = $redis
      raise '请不要重复提交订单' if order_hash[:redis_expire_name].blank? or redis.get(order_hash[:redis_expire_name]) == 'true'
      redis.set(order_hash[:redis_expire_name], true)
      redis.expire(order_hash[:redis_expire_name], 5 * 60)
      @@order_logger.info (Time.now.to_s + {'m_name' => 'SET_TRANSACTION_REDIS_EXPIRE_TIME', "#{order_hash[:redis_expire_name]}" => redis.get(order_hash[:redis_expire_name]), 'ORDER_HASH' => order_hash}.to_s)
    end

    def check_user order_hash, params
      return if order_hash[:user].present?
      user = User.where(phone_number: params[:customer_phone_number]).first
      return order_hash[:user] = user if user.present?
      
      user = build_user_from_params params
      if !user.valid? || !user.save
        @@order_logger.info (Time.now.to_s + {'m_name' => 'CREATE_USER_ERRORS', 'user' => user, 'ERRORS' => user.errors}.to_s)
        raise user.errors
      end
      order_hash[:user] = user
      @@order_logger.info (Time.now.to_s + {'m_name' => 'AFTER_CREATE_USER', 'order_hash_USER' => order_hash[:user]}.to_s)
    end

    def build_user_from_params params
      mobile = params[:customer_phone_number]
      User.new(phone_number: mobile, name: params[:customer_name])
    end

    def create_order order_hash, params
      order = build_order_params(order_hash, params)
      if !order.valid? || !order.save
        @@order_logger.info (Time.now.to_s + {'m_name' => 'CREATE_USER_ERRORS', 'order' => order, 'ERRORS' => order.errors}.to_s)
        raise order.errors
      end
      order_hash[:order] = order
      #save_with_new_external_id(order_hash, params)
      @@order_logger.info (Time.now.to_s + {'m_name' => 'AFTER_CREATE_ORDER', 'order_hash_USER' => order_hash[:order]}.to_s)
    end

    def build_order_params order_hash, params
      order_attr = order_hash[:order_attr] || {}
      order_attr = order_attr.merge!(
        user_id: order_hash[:user_id] || order_hash[:user].try(:id),
        customer_name: order_attr[:customer_name] || order_hash[:customer_name] || order_hash[:user].try(:name),
        purchased_items_attributes: order_hash[:purchased_items] || []
      )
      Order.new(order_attr)
    end

    def create_tenpay_order_payment_record(order_hash, params)
      raise '订单不存在' if order_hash[:order].blank?
      order = order_hash[:order]
      product_cost = order.purchased_items.sum('price * quantity')
      total_cost = product_cost.round(2)
      order_payment_record = order.order_payment_records.build({payment_method_id: Order::TENPAY_ID, payment_method_name: '收纳工具收入', cost: total_cost, out_trade_no: order.next_payment_method_num(Order::TENPAY_ID)})
      order_payment_record.save!
      order_hash[:order_payment_record] = order_payment_record
    end

    def cancel_order order_hash, params
      raise '订单不存在' if order_hash[:order].blank?
      order = order_hash[:order]
      order.update_attributes!(status: 'canceled')
    end

    def create_course_student order_hash, params
      order = order_hash[:order]
      user = order_hash[:user]
      raise '不能创建学员' if order.blank? or user.blank?
      order.purchased_items.each do |item|
        course = Course.find(item.product_id)
        student = Student.where(course_id: course.id, user_id: user.id,  order_id: order.id).first_or_create
        student.update_attributes!(notes: order.notes, city_name: order.city_name, name: order.customer_name, phone_number: user.phone_number)
        order_hash[:student] = student
      end
    end

    def save_with_new_external_id(order_hash, params)
      order = order_hash[:order]
      if order.start_date.present?
        start = order.start_date.split('-').join('')
      else
        start = Time.now.strftime('%Y%m%d')
      end
      prefix = order.order_type[0] + 'O'
      max_id = ExternalId.where(prefix: prefix, date: start).first_or_create
      result = nil
      max_id.with_lock do
        new_num = max_id.number + 1
        order.external_id = prefix + start + sprintf('%04d', new_num)
        result = order.save!
        if result
          max_id.update(number: new_num)
        end
      end
      order_hash[:order] = order
    end

    def update_order order_hash, params
      raise '订单不存在' if order_hash[:order].blank? or order_hash[:order_attr].blank?
      order = order_hash[:order]
      raise order.errors unless order.update(order_hash[:order_attr])
      order_hash[:order] = order
    end

    def update_order_payment_record order_hash, params
      raise '付款记录不存在' if order_hash[:current_payment_record].blank?
      item = order_hash[:current_payment_record]
      raise item.errors unless item.update(timestamp: Time.now)
      order_hash[:current_payment_record] = item
    end

    def update_order_transfer_info(option={})
      order_payment_record = OrderPaymentRecord.where(out_trade_no: option[:out_trade_no]).first
      order = order_payment_record.order
      return nil if order.blank?
      return nil if order.no_paid_due <= 0 or option[:transfer_received].to_f < order_payment_record.cost
      order_payment_record.transaction_id = option[:transaction_id]
      order_attr = {}
      if order.order_type == "Product"
        order_attr[:status] = 'paided'
      elsif order.total_unpaid_fee <= option[:transfer_received].to_f
        order_attr[:status] = 'paided'
      else
        order_attr[:status] = 'part-paid'
      end
      order_info = {order_attr: order_attr, order: order, params: option}
      order_info[:methods] = %w(update_order update_order_payment_record)
      order_info[:current_payment_record] = order_payment_record
      order_info[:redis_expire_name] = "order-#{order.id}"
      order, success, errors = Order.create_or_update_order(order_info)
      order
    end
  end
end
