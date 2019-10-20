class Admin::OrderPaymentRecordsController < Admin::BaseController
  layout 'admin'
  before_action :get_order

  def index
    @items = @order.order_payment_records.page(params[:page])
  end

  def new
    @item = @order.order_payment_records.build

  end

  def create
    @item = @order.order_payment_records.build(current_record_params)
    if @item.save
      redirect_to admin_order_order_payment_records_path(@order)
    else
      render :new
    end
  end

  def update
    @item = OrderPaymentRecord.find(params[:id])
    if @item.update_attributes(current_record_params)
      redirect_to admin_order_order_payment_records_path(@order)
    else
      render :edit
    end
  end

  def edit
    @item = OrderPaymentRecord.find(params[:id])
  end

  def destroy
    @item = OrderPaymentRecord.find(params[:id])
    redirect_to admin_order_order_payment_records_path(@order) if @item.destroy
  end

  private

  def current_record_params
    params.require(:order_payment_record).permit!
  end

  def get_order
    @order = Order.find(params[:order_id])
  end
end