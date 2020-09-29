class Admin::AppliesController < Admin::BaseController
  layout 'admin'

  def index
    @items, @params, @q = Apply.search_result(params)
    @items = @q.result(distinct: true).page(params[:page])
    @users_hash = User.where(id: @items.map(&:user_id)).map{|u| [u.id, u]}.to_h
    @admins_hash = Admin.where(id: @items.map(&:admin_id)).pluck(:id, :name).to_h
  end

  def update
    @item = Apply.find(params[:id])
    @item.admin_id = @admin.id
    if @item.update_attributes(current_record_params)
      redirect_to admin_applies_path
    else
      load_order_and_payment_records_infos
      render :edit
    end
  end

  def edit
    @item = Apply.find(params[:id])
    load_order_and_payment_records_infos
  end


  def update_status
    item = Apply.find(params[:id])
    if item.update_attributes(status: params[:status])
      redirect_back(fallback_location: admin_applies_path, notice: '成功')
    else
      redirect_back(fallback_location: admin_applies_path, alert: '失败')
    end
  end

  def completed
    item = Apply.find(params[:id])
    if item.do_completed
      redirect_back(fallback_location: admin_applies_path, notice: '成功')
    else
      redirect_back(fallback_location: admin_applies_path, alert: '失败')
    end
  end

  def canceled
    item = Apply.find(params[:id])
    if item.do_canceled
      redirect_back(fallback_location: admin_applies_path, notice: '成功')
    else
      redirect_back(fallback_location: admin_applies_path, alert: '失败')
    end
  end

  private

  def current_record_params
    params.require(:apply).permit!
  end

  def load_order_and_payment_records_infos
    @apply_items = @item.apply_items
    order_ids = @apply_items.map(&:item_id).uniq
    @order_infos = Order.noncanceled.includes(:purchased_items).where(id: order_ids)
    product_ids = PurchasedItem.where(order_id: order_ids).pluck(:product_id)
    @product_hash = Product.where(id: product_ids).map{|i| [i.id, i]}.to_h
    @order_payment_records = OrderPaymentRecord.where(order_id: order_ids)
    @total_fee = Order.user_orders_achievement(@order_infos)
  end

end