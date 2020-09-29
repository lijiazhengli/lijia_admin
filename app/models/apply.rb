class Apply < ApplicationRecord
  belongs_to :user
  has_many  :apply_items
  accepts_nested_attributes_for :apply_items, allow_destroy: true


  scope :noncanceled, -> { where.not(status: ['canceled']) }
  scope :order_fee_list, -> { where(status: AVAILABLE_STATUS, item_type: 'OrderFee') }
  AVAILABLE_STATUS = ['unconfirmed', 'completed']

  ITEM_TYPE = {
    'OrderFee'       => '整理服务费'
  }


  ORDER_FEE_TYPE = 'OrderFee'

  STATUS = {
    'unconfirmed'       => '待确认',
    'completed'    => '已完成',
    'canceled'     => '已取消'
  }


  def do_completed
    success = self.update!(status: 'completed')
    Order.where(id: self.apply_items.pluck(:item_id).uniq).update_all(status: 'completed')
    success
  end

  def do_canceled
    success = self.update!(status: 'canceled')
    self.apply_items.update_all(status: 'canceled')
    success
  end

  class << self
    def search_result(params)
      @params = params[:q] || {}
      user_ids = []
      if params[:user_id].present?
        user_ids << params[:user_id].to_i
        @params[:customer_phone_number_cont] = (User.find(params[:user_id]).phone_number rescue '')
      end
      if params[:customer_name_cont].present?
        user_ids += User.ransack(name_cont: params[:customer_name_cont]).result(distinct: true).pluck(:id).uniq
      end

      if params[:customer_phone_number_cont].present?
        user_ids += User.ransack(phone_number_cont: params[:customer_phone_number_cont]).result(distinct: true).pluck(:id).uniq
      end
      @params[:user_id_in] = user_ids
   
      @q = Apply.noncanceled.ransack(@params)

      orders = @q.result(distinct: true)
      orders = [] if params[:customer_name_cont].present? and @params[:user_id_in].blank?

      return [orders, @params, @q]
    end

    def create_order_fee_apply_for_applet option
      msg = check_order_fee_apply_option(option)
      return [nil, false, msg] if msg.present?
      return [nil, false, '含有已申请费用的订单，请核对'] unless ApplyItem.includes(:apply).where(item_type: 'Order', item_id: option[:order_ids], applies: {status: AVAILABLE_STATUS}).empty?
      total_cost = Order.user_orders_achievement(Order.noncanceled.where(id: option[:order_ids]))
      return [nil, false, '订单金额已变更， 请重新提交申请'] if (total_cost.round(2) - option[:total_fee].to_f).abs >= 0.5
      user = User.where(phone_number: option[:customer_phone_number]).last
      success = false
      msg = nil
      apply = nil
      begin
        Apply.transaction do
          apply_items_attributes = []
          option[:order_ids].each do |order_id|
            apply_items_attributes << {item_type: 'Order', item_id: order_id}
          end
          apply = Apply.create!(user_id: user.id, item_type: Apply::ORDER_FEE_TYPE, cost: option[:total_fee], apply_items_attributes: apply_items_attributes)
          success = true
          $redis.del(option[:redis_expire_name]) if option[:redis_expire_name].present?
        end
      rescue Exception => exp
        msg = exp.message
        $redis.del(option[:redis_expire_name]) if option[:redis_expire_name].present?
      end
      [apply, success, msg]
    end

    def check_order_fee_apply_option option
      return '申请费用的用户不存在' if option[:customer_phone_number].blank?
      return '没有申请费用的订单' if option[:order_ids].blank?
      return '申请费用必须大于0' if option[:total_fee].to_f <= 0
      nil
    end

    def check_redis_expire_name(option)
      redis = $redis
      return '请不要重复提交' if option[:redis_expire_name].blank? or redis.get(option[:redis_expire_name]) == 'true'
      redis.set(option[:redis_expire_name], true)
      redis.expire(option[:redis_expire_name], 5 * 60)
      nil
    end
  end
end
