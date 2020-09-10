class AddOperateUserIdToOrderPaymentRecord < ActiveRecord::Migration[6.0]
  def change
    add_column :order_payment_records, :operate_user_id, :integer
  end
end
