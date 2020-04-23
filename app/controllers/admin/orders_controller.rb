class Admin::OrdersController < Admin::BaseController
  layout 'admin'

  def index
    p params
    @params = params[:q] || {}
    if params[:order_type].present?
      @params[:order_type_eq] = params[:order_type]
    end

    if params[:user_id].present?
      @params[:customer_phone_number_cont] = (User.find(params[:user_id]).phone_number rescue '')
    end
    @q = Order.noncanceled.order('id desc').ransack(@params)
    @orders = @q.result(distinct: true).page(params[:page])
    @admins_hash = Admin.where(id: @orders.map(&:admin_id)).pluck(:id, :name).to_h
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
      redirect_back(fallback_location: admin_orders_path, notice: '成功')
    else
      redirect_back(fallback_location: admin_orders_path, alert: '失败')
    end
  end

  def completed
    p params
    item = Order.find(params[:id])
    p item
    if item.do_completed
      redirect_back(fallback_location: admin_orders_path, notice: '成功')
    else
      redirect_back(fallback_location: admin_orders_path, alert: '失败')
    end
  end

  def canceled
    item = Order.find(params[:id])
    if item.do_canceled
      redirect_back(fallback_location: admin_orders_path, notice: '成功')
    else
      redirect_back(fallback_location: admin_orders_path, alert: '失败')
    end
  end

  def accounting
    p params
    product_ids = params[:product_ids].present? ? params[:product_ids].split(',') : []
    @params = params[:q] || {}
    if params[:order_type].present?
      @params[:order_type_eq] = params[:order_type]
    end

    @params = params[:q] || {}
    if product_ids.present?
      @q = Order.noncanceled.includes(:order_payment_records, :purchased_items).references(:order_payment_records, :purchased_items).where('order_payment_records.timestamp != ? or order_payment_records.timestamp != ?', nil, '').where(purchased_items: {product_id: product_ids}).order('orders.id desc').ransack(@params)
    else
      @q = Order.noncanceled.includes(:order_payment_records, :purchased_items).references(:order_payment_records, :purchased_items).where('order_payment_records.timestamp != ? or order_payment_records.timestamp != ?', nil, '').order('orders.id desc').ransack(@params)
    end

    @orders = @q.result(distinct: true).page(params[:page])
    order_ids = @q.result(distinct: true).map(&:id).uniq
    @order_paided_count = OrderPaymentRecord.where(order_id: order_ids).where.not(timestamp: nil).sum(:cost)
    @order_unpaid_count = OrderPaymentRecord.where(order_id: order_ids, timestamp: nil).sum(:cost)
    product_ids = PurchasedItem.where(order_id: @orders.map(&:id).uniq).pluck(:product_id) if product_ids.blank?
    @product_hash = Product.get_product_list_hash(product_ids)
  end


  private

  def current_record_params
    params.require(:order).permit!
  end 

end