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
    @q = Order.order('id desc').ransack(@params)
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
      redirect_back(fallback_location: admin_orders_path, alert: '成功')
    else
      redirect_back(fallback_location: admin_orders_path, alert: '失败')
    end
  end

  def completed
    p params
    item = Order.find(params[:id])
    p item
    if item.do_completed
      redirect_back(fallback_location: admin_orders_path, alert: '成功')
    else
      redirect_back(fallback_location: admin_orders_path, alert: '失败')
    end
  end

  def canceled
    item = Order.find(params[:id])
    if item.do_canceled
      redirect_back(fallback_location: admin_orders_path, alert: '成功')
    else
      redirect_back(fallback_location: admin_orders_path, alert: '失败')
    end
  end


  private

  def current_record_params
    params.require(:order).permit!
  end 

end