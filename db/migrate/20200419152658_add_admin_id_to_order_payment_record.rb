class AddAdminIdToOrderPaymentRecord < ActiveRecord::Migration[6.0]
  def change
  	add_column :order_payment_records, :admin_id, :integer
  	add_column :order_payment_records, :batch_no, :string, limit: 20
  	add_column :order_payment_records, :remark, :text
  	add_index :order_payment_records, :batch_no
  	add_index :order_payment_records, :transaction_id

  	add_column :order_payment_records, :created_at, :datetime
  	add_column :order_payment_records, :updated_at, :datetime
  end
end
