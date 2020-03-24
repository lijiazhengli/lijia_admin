class Admin::DeliveryOrdersController < Admin::BaseController
  layout 'admin'
  before_action :get_order

  def index
    @items = @order.delivery_orders.page(params[:page])
  end

  def new
    @item = @order.delivery_orders.build
    @purchased_items = @order.purchased_items
    @product_hash = Product.where(id: @purchased_items.map(&:product_id)).pluck(:id, :title).to_h
  end

  def create
    @item = @order.delivery_orders.build(current_record_params)
    if @item.save
      redirect_to admin_order_delivery_orders_path(@order)
    else
      @purchased_items = @order.purchased_items
      @product_hash = Product.where(id: @purchased_items.map(&:product_id)).pluck(:id, :title).to_h
      render :new
    end
  end

  def update
    @item = DeliveryOrder.find(params[:id])
    @item.purchased_item_ids = [] if current_record_params['purchased_item_ids'].blank?
    if @item.update_attributes(current_record_params)
      redirect_to admin_order_delivery_orders_path(@order)
    else
      @purchased_items = @order.purchased_items
      @product_hash = Product.where(id: @purchased_items.map(&:product_id)).pluck(:id, :title).to_h
      render :edit
    end
  end

  def edit
    @item = DeliveryOrder.find(params[:id])
    @purchased_items = @order.purchased_items
    @product_hash = Product.where(id: @purchased_items.map(&:product_id)).pluck(:id, :title).to_h
  end

  def destroy
    @item = DeliveryOrder.find(params[:id])
    redirect_to admin_order_delivery_orders_path(@order) if @item.destroy
  end

  private

  def current_record_params
    params.require(:delivery_order).permit!
  end

  def get_order
    @order = Order.find(params[:order_id])
  end
end