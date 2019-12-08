class Order < ApplicationRecord
  has_many  :order_payment_records
  accepts_nested_attributes_for :order_payment_records, allow_destroy: true

  has_many  :order_arranger_assignments
  has_many  :arrangers, through: :order_arranger_assignments

  has_many :purchased_items
  accepts_nested_attributes_for :purchased_items, allow_destroy: true

  ORDER_TYPE = {
    'Service'       => '整理服务',
    'Course'       => '课程培训',
    'Product'       => '收纳功能'
  }

  SERVICE_ORDER = 'Service'
  COURSE_ORDER = 'Course'

  STATUS = {
    'unpaid'       => '待支付',
    'paided'       => '已支付',
    'completed'    => '已完成',
    'canceled'     => '已取消'
  }


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


  def no_payed_due
    product_cost = self.purchased_items.sum('price * quantity')
    total_cost = product_cost.round(2)
    total_cost
  end

  def order_transfer_info(pay_method)
    [self.external_id, self.no_payed_due]
  end

  def weixin_pay_json(ip, openid, wx_attr = {})
    return {} if openid.blank?
    trade_no, trade_due = self.order_transfer_info('tenpay')
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
      str = "appId=#{option[:appId]}&nonceStr=#{option[:nonceStr]}&package=#{option[:package]}&signType=#{option[:signType]}&timeStamp=#{option[:timeStamp]}&key=#{ENV['WX_API_KEY']}"
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
        check_user create_order create_course_student save_with_new_external_id
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
      save_with_new_external_id(order_hash, params)
      @@order_logger.info (Time.now.to_s + {'m_name' => 'AFTER_CREATE_ORDER', 'order_hash_USER' => order_hash[:order]}.to_s)
    end

    def build_order_params order_hash, params
      order_attr = order_hash[:order_attr] || {}
      order_attr = order_attr.merge!(
        user_id: order_hash[:user_id] || order_hash[:user].try(:id),
        purchased_items_attributes: order_hash[:purchased_items] || []
      )
      Order.new(order_attr)
    end

    def create_course_student order_hash, params
      order = order_hash[:order]
      user = order_hash[:user]
      raise '不能创建学员' if order.blank? or user.blank?
      order.purchased_items.each do |item|
        course = Course.find(item.product_id)
        student = Student.where(course_id: course.id, user_id: user.id,  order_id: order.id).first_or_create
        student.update_attributes!(notes: order.notes, city_name: order.city_name)
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
  end
end
