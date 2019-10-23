class OrderPaymentRecord < ActiveRecord::Base
  belongs_to :order

  PAYMENT_METHOD_ID = {1 => '现金', 2 => '财付通', 3 => '支付宝', 4 => '银行转账'}
end