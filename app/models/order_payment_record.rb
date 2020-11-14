class OrderPaymentRecord < ActiveRecord::Base
  belongs_to :order
  PAYMENT_METHOD_ID = {1 => '现金', 2 => '微信付款', 3 => '支付宝', 4 => '银行转账', 5 => '服务费定金', 6 => '服务费尾款现金', 7 => '收纳工具结算现金', 8 => '银行转账', 9 => '课程尾款现金'}
  APPLET_SELECT_PAYMENT_METHOD_ID = ['服务费定金', '服务费尾款现金', '收纳工具结算现金', '课程尾款现金']
  scope :tenpay_method, -> {where(payment_method_id: Order::TENPAY_ID)}
  scope :untenpay_method, -> {where.not(payment_method_id: Order::TENPAY_ID)}
  scope :paid, -> {where.not(timestamp: nil)}
  scope :unpaid, -> {where(timestamp: nil)}
  scope :tongji, -> {where.not(payment_method_id: 7)}

  def payment_name
    OrderPaymentRecord::PAYMENT_METHOD_ID[self.payment_method_id]
  end

  def create_refund_record(admin, params)
    attrs = {
      order_id: self.order_id,
      payment_method_id: self.payment_method_id,
      cost: params[:cost],
      payment_method_name: "#{PAYMENT_METHOD_ID[self.id]}退款",
      out_trade_no: self.out_trade_no,
      transaction_id: self.transaction_id,
      remark: params[:remark]
    }
    attrs[:batch_no] = DateTime.now.strftime('%Y%m%d%H%M%S%L')
    attrs[:admin_id] = admin.try(:id)
    OrderPaymentRecord.create!(attrs)
  end

  # 退款记录对应的支付记录的支付金额
  def pay_cost
    OrderPaymentRecord.where("cost > ? and transaction_id=?", 0, self.transaction_id).first.try(:cost).round(2)
  end

  def confirm_paid_or_operate
    self.update(timestamp: Time.now)
    self.order.update(status: 'paided')
    return [true, nil]
  end

  def reimbursement
    success = false
    msg = nil
    return [false, '订单已经退款！'] if self.timestamp.present?
    params = {
      transaction_id: self.transaction_id,
      out_refund_no: self.batch_no,
      total_fee: (self.pay_cost * 100).round,
      refund_fee: (-self.cost * 100).round,
    }
    result = WxPay::Service.invoke_refund params, self.order.get_wxpay_option
    if result['return_code'] == "SUCCESS" && result['result_code'] == "SUCCESS"
      success = self.update_attributes(timestamp: Time.now, refund_id: result['refund_id'])
    else
      msg = "#{self.payment_method_name}失败"
    end
    [success, msg]
  end
end