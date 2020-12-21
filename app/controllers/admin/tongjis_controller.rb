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

  def city
    orders, @params, @q = Order.search_result(params)
    if params['commit'] != '导出数据'
      @orders = orders.page(params[:page]).per(100)
      @users_hash = User.where(id: @orders.map(&:user_id)).pluck(:id, :phone_number).to_h
      product_ids = PurchasedItem.where(order_id: @orders.map(&:id).uniq).pluck(:product_id)
      @product_hash = Product.get_product_list_hash(product_ids)
      @referral_infos = User.where(phone_number: @orders.map(&:referral_phone_number)).map{|i| [i.phone_number, i]}.to_h
      @order_payment_records = OrderPaymentRecord.where(order_id: @orders.map(&:id))
    else
      return send_data(Export::Tongji.city(orders), :type => "text/excel;charset=utf-8; header=present", :filename => "订单地址统计#{Time.now.strftime('%Y%m%d%H%M%S%L')}.xls" )
    end
  end

  def course
    @params = params[:q] || {}
    @params[:order_type] = 'Course'

    product_ids = params[:product_ids].present? ? params[:product_ids].split(',') : []
    if product_ids.present?
      @q = Order.noncanceled.includes(:purchased_items, :order_payment_records).where(purchased_items: {product_id: product_ids}).ransack(@params)
    else
      @q = Order.noncanceled.includes(:purchased_items, :order_payment_records).ransack(@params)
    end
    @orders = @q.result(distinct: true)
    @result = {}
    @orders.each do |order|
      next if order.city_name.blank?
      info = @result[order.city_name] || {}
      show_time = order.tongji_course_show_date
      info_value = info[show_time] || {"part-paid_count" => 0, "paided_count" => 0, 'other_count' => 0, 'unpaid' => 0, 'part-paid' => 0, 'paided' => 0, "unpaid_count" => 0, 'other' => 0,  "paided_value" => 0}
      if ['unpaid', 'part-paid', 'paided'].include?(order.status)
        info_value["#{order.status}_count"] = info_value["#{order.status}_count"] + 1
        info_value[order.status] = info_value[order.status] + order.order_payment_records.paid.sum(:cost)
      else
        info_value['other_count'] = info_value['other_count'] + 1
        info_value['other'] = info_value['other'] + order.order_payment_records.paid.sum(:cost)
      end
      info_value['paided_value'] = info_value['paided_value'] + order.order_payment_records.paid.sum(:cost)
      info[show_time] = info_value
      @result[order.city_name] = info
    end

    p @result
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


  def good

    product_ids = params[:product_ids].present? ? params[:product_ids].split(',') : []
    params[:q] ||= {}
    params[:q][:created_at_gteq] ||= (Time.now - 1.days).strftime("%F")
    params[:q][:created_at_lteq] ||= (Time.now + 1.days).strftime("%F")
    @params = params[:q]

    if product_ids.present?
      @q = Order.goods.noncanceled.includes(:purchased_items).where(purchased_items: {product_id: product_ids}).ransack(@params)
    else
      @q = Order.goods.noncanceled.ransack(@params)
    end
    @orders = @q.result(distinct: true)
    if product_ids.present?
      @purchased_items = PurchasedItem.where(product_id: product_ids).where(order_id: @orders.map(&:id).uniq).order('order_id desc')
    else
      @purchased_items = PurchasedItem.where(order_id: @orders.map(&:id).uniq).order('order_id desc')
    end
    product_ids = PurchasedItem.where(order_id: @orders.map(&:id).uniq).pluck(:product_id) if product_ids.blank?
    @product_hash = Product.get_product_list_hash(product_ids)
  end
end