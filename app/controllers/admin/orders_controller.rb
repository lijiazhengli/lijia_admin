class Admin::OrdersController < Admin::BaseController
  layout 'admin'

  def index
    p params
    @params = params[:q] || {}
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

    option[:methods] = %w(check_user create_order save_with_new_external_id)
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


  private

  def current_record_params
    params.require(:order).permit!
  end 

end