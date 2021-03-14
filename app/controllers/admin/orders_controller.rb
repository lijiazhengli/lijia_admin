class Admin::OrdersController < Admin::BaseController
  layout 'admin'

  def index
    @orders, @params, @q = Order.search_result(params)
    if params['commit'] != '导出数据'
      @orders = @q.result(distinct: true).page(params[:page]).per(100)
      @users_hash = User.where(id: @orders.map(&:user_id)).pluck(:id, :name).to_h
      @admins_hash = Admin.where(id: @orders.map(&:admin_id)).pluck(:id, :name).to_h
      product_ids = PurchasedItem.where(order_id: @orders.map(&:id).uniq).pluck(:product_id)
      @product_hash = Product.get_product_list_hash(product_ids)
      @referral_infos = User.where(phone_number: @orders.map(&:referral_phone_number)).map{|i| [i.phone_number, i]}.to_h
    else
      return send_data(Export::Order.list(@orders), :type => "text/excel;charset=utf-8; header=present", :filename => "订单统计#{Time.now.strftime('%Y%m%d%H%M%S%L')}.xls" )
    end
  end

  def new
    @order = Order.new(admin_id: @admin.id, order_type: params[:order_type] || 'Service')
  end

  def create
    params_attr = params[:order]
    
    order_attr = params.require(:order).permit!
    option = {order_attr: order_attr, params: params_attr}

    if params[:purchased_item_id].present?
      product = Product.find(params[:purchased_item_id])
      option[:purchased_items] = [{product_id: params[:purchased_item_id], quantity: params[:quantity] || 1, price: product.price}]
    end

    if params_attr[:order_type] == Order::COURSE_ORDER
      option[:methods] = %w(check_user create_order create_course_student save_with_new_external_id)
    else
      option[:methods] = %w(check_user create_order save_with_new_external_id)
    end
    option[:redis_expire_name] = "cart-#{order_attr[:customer_phone_number]}"

    @order, success, @errors = Order.create_or_update_order(option)
    if success
      redirect_to admin_orders_path
    else
      @order = Order.new(current_record_params)
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def base_show
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    if @order.update_attributes(current_record_params)
      redirect_to admin_orders_path
    else
      render :edit
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update_status
    item = Order.find(params[:id])
    if item.update_attributes(status: params[:status])
      redirect_back(fallback_location: admin_orders_path, notice: '操作成功')
    else
      redirect_back(fallback_location: admin_orders_path, alert: '操作失败')
    end
  end

  def completed
    item = Order.find(params[:id])
    if item.do_completed
      redirect_back(fallback_location: admin_orders_path, notice: '已操作完成')
    else
      redirect_back(fallback_location: admin_orders_path, alert: '操作失败')
    end
  end

  def canceled
    item = Order.find(params[:id])
    success, errors = item.do_canceled
    if success
      redirect_back(fallback_location: admin_orders_path, notice: '取消成功')
    else
      redirect_back(fallback_location: admin_orders_path, alert: errors)
    end
  end

  def accounting
    @orders, @params, @q = Order.search_result(params, true)
    if params['commit'] != '导出数据'
      @orders = @q.result(distinct: true).page(params[:page]).per(100)
      order_ids = @q.result(distinct: true).map(&:id).uniq
      @order_paided_count = OrderPaymentRecord.where(order_id: order_ids).where.not(timestamp: nil).sum(:cost)
      @order_unpaid_count = OrderPaymentRecord.where(order_id: order_ids, timestamp: nil).sum(:cost)
      product_ids = PurchasedItem.where(order_id: @orders.map(&:id).uniq).pluck(:product_id) if product_ids.blank?
      @product_hash = Product.get_product_list_hash(product_ids)
      @users = User.where(id: @orders.map(&:user_id))
      phone_numbers =  @orders.map(&:referral_phone_number) + @orders.map(&:organizer_phone_number)
      @phone_numbers_infos = User.where(phone_number: phone_numbers).map{|i| [i.phone_number, i]}.to_h
      @order_payment_records = OrderPaymentRecord.where("timestamp is not null").where(order_id: order_ids)
    else
      return send_data(Export::Accounting.list(@orders), :type => "text/excel;charset=utf-8; header=present", :filename => "订单收入统计#{Time.now.strftime('%Y%m%d%H%M%S%L')}.xls" )
    end
  end


  private

  def current_record_params
    params.require(:order).permit!
  end 

end