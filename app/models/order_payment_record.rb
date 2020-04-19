class OrderPaymentRecord < ActiveRecord::Base
  belongs_to :order
  PAYMENT_METHOD_ID = {1 => '现金', 2 => '微信付款', 3 => '支付宝', 4 => '银行转账'}

  scope :tenpay_method, -> {where(payment_method_id: Order::TENPAY_ID)}
  scope :paid, -> {where.not(timestamp: nil)}
  scope :unpaid, -> {where(timestamp: nil)}

  def payment_name
    OrderPaymentRecord::PAYMENT_METHOD_ID[self.payment_method_id]
  end

  def create_refund_record(admin, params)
    attrs = {
      order_id: self.order_id,
      payment_method_id: self.payment_method_id,
      cost: params[:cost],
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
    OrderPaymentRecord.where("cost > ? and transaction_id=?", 0, self.transaction_id).first.try(:cost)
  end

  def reimbursement
    return '订单已经退款！' if self.timestamp.present?
    params = {
      transaction_id: self.transaction_id,
      out_refund_no: self.batch_no,
      total_fee: (-self.pay_cost * 100).to_i,
      refund_fee: (-self.cost * 100).to_i,
    }
    result = WxPay::Service.invoke_refund params, {appid: ENV['WX_MINIAPPLET_APP_ID'], mch_id: ENV['WX_MCH_ID']}
    if result['return_code'] == "SUCCESS" && result['result_code'] == "SUCCESS"
      return self.update_attributes(timestamp: Time.now)
    else
      return false
    end
  end
end