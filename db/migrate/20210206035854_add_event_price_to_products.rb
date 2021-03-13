class AddEventPriceToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :event_price, :float, comment: '活动金额'
  end
end
