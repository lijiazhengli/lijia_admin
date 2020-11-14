class AddWxPayTypeToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :wx_pay_type, :string, default: 'Product'
  end
end
