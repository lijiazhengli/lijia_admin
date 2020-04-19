class Admin::OrderPaymentRecordsController < Admin::BaseController
  layout 'admin'
  before_action :get_order
  skip_before_action :admin_required, only: [:received, :cancel]

  def index
    if @order.present?
      @items = @order.order_payment_records.page(params[:page])
      render :order_index
    else
      @params = params[:q] || {}
      @q = OrderPaymentRecord.includes(:order).references(:order).where('orders.status != ?', 'canceled').ransack(@params)
      @items = @q.result(distinct: true).page(params[:page])

    end
  end

  def new
    @item = @order.order_payment_records.build

  end

  def create
    attrs = current_record_params
    attrs[:out_trade_no] = @order.next_payment_method_num(current_record_params[:payment_method_id]) if [Order::TENPAY_ID].include?(current_record_params[:payment_method_id].to_i) and current_record_params[:out_trade_no].blank?

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

  def received
    @item = OrderPaymentRecord.find(params[:order_payment_record_id])
    if @item.update_attributes(timestamp: params[:date_string])
      redirect_back(fallback_location: admin_order_payment_records_path, alert: '成功')
    else
      redirect_back(fallback_location: admin_order_payment_records_path, alert: '失败')
    end 
  end

  def cancel
    @item = OrderPaymentRecord.find(params[:id])
    if @item.update_attributes(timestamp: nil)
      redirect_back(fallback_location: admin_order_payment_records_path, alert: '成功')
    else
      redirect_back(fallback_location: admin_order_payment_records_path, alert: '失败')
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
    @order = Order.find(params[:order_id]) rescue nil
  end
end