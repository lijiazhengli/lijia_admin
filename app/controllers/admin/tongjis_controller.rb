class Admin::TongjisController < Admin::BaseController
  layout 'admin'
  def achievement
    p params
    @orders, @params, @q = Order.search_result(params, true)
    results = {}
    @per_infos = PercentInfo.all.order('id desc')
    @orders.select{|i| i.order_type == 'Service'}.each do |o|
      results = update_result_info(results, o, o.organizer_phone_number, [:service_yeji_order_ids])
      results = update_result_info(results, o, o.referral_phone_number, [:service_ticheng_order_ids])
    end

    @orders.select{|i| i.order_type == 'Course'}.each do |o|
      results = update_result_info(results, o, o.referral_phone_number, [:course_ticheng_order_ids, :course_yeji_order_ids])
    end

    @orders.select{|i| i.order_type == 'Product'}.each do |o|
      results = update_result_info(results, o, o.referral_phone_number || o.user.try(:phone_number), [:product_yeji_order_ids])
    end
    @results = results
    @users = User.where(phone_number: results.keys)
  end

  def update_result_info(results, order, phone_number, order_ids)
    return results if phone_number.blank?
    info = results[phone_number] || {}
    order_ids.each do |item|
      order_ids = info[item] || []
      order_ids << order.id
      info[item] = order_ids.uniq
    end
    results[phone_number] = info
    results
  end
end