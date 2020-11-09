class Admin::PurchasedItemsController < Admin::BaseController
  layout 'admin'
  before_action :get_order

  def index
    @items = @order.purchased_items.page(params[:page]).per(100)
    @product_hash = Product.where(id: @items.map(&:product_id)).pluck(:id, :title).to_h
  end

  def new
    @item = @order.purchased_items.build

  end

  def create
    @item = @order.purchased_items.build(current_record_params)
    if @item.save
      redirect_to admin_order_purchased_items_path(@order)
    else
      render :new
    end
  end

  def update
    @item = PurchasedItem.find(params[:id])
    if @item.update_attributes(current_record_params)
      redirect_to admin_order_purchased_items_path(@order)
    else
      render :edit
    end
  end

  def edit
    @item = PurchasedItem.find(params[:id])
  end

  def destroy
    @item = PurchasedItem.find(params[:id])
    redirect_to admin_order_purchased_items_path(@order) if @item.destroy
  end

  private

  def current_record_params
    params.require(:purchased_item).permit!
  end

  def get_order
    @order = Order.find(params[:order_id])
    @order_type = Order::ORDER_TYPE[@order.order_type]
  end
end