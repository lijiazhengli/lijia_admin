class AddRefundIdToOrderPaymentRecord < ActiveRecord::Migration[6.0]
  def change
  	add_column :order_payment_records, :refund_id, :string
  end
end
