class OrderPaymentRecord < ActiveRecord::Base
  belongs_to :order
  PAYMENT_METHOD_ID = {1 => '现金', 2 => '微信付款', 3 => '支付宝', 4 => '银行转账'}

  scope :tenpay_method, -> {where(payment_method_id: Order::TENPAY_ID)}
  scope :paid, -> {where.not(timestamp: nil)}
  scope :unpaid, -> {where(timestamp: nil)}
end