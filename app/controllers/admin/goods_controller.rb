class Admin::GoodsController < Admin::BaseController
  layout 'admin'
  skip_before_action :admin_required, only: [:file_upload]

  def index
    @params = params[:q] || {}
    @q = Good.order('active desc, position asc').ransack(@params)
    @items = @q.result(distinct: true).page(params[:page])
  end

  def new
    @good = Good.new
  end

  def create
    @good = Good.new(current_record_params)
    if @good.save
      redirect_to admin_goods_path
    else
      render :new
    end
  end

  def update
    @good = Good.find(params[:id])
    if @good.update_attributes(current_record_params)
      redirect_to admin_goods_path
    else
      render :edit
    end
  end

  def edit
    @good = Good.find(params[:id])
  end

  def destroy
    @good = Good.find(params[:id])
    redirect_to :back if @good.destroy
  end

  def file_upload
    file_upload_to_qiniu('good')
  end

  def up_serial
    item = Good.where(id: params[:id]).first
    if item.up_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  def down_serial
    item = Good.where(id: params[:id]).first
    if item.down_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  def enable
    item = Good.find(params[:id])
    if item.enable
      redirect_to admin_goods_path, notice: '成功'
    else
      redirect_to admin_goods_path, alert: '失败'
    end
  end

  def disable
    item = Good.find(params[:id])
    if item.disable
      redirect_to admin_goods_path, notice: '成功'
    else
      redirect_to admin_goods_path, alert: '失败'
    end
  end

  def order
    product_ids = params[:product_ids].present? ? params[:product_ids].split(',') : []
    @params = params[:q] || {}

    if params[:customer_name_cont].present?
      @params[:user_id_in] = User.ransack(name_cont: params[:customer_name_cont]).result(distinct: true).pluck(:id).uniq
    end

    if product_ids.present?
      @q = Order.goods.noncanceled.includes(:purchased_items).where(purchased_items: {product_id: product_ids}).order('orders.id desc').ransack(@params)
    else
      @q = Order.goods.noncanceled.includes(:purchased_items).order('orders.id desc').ransack(@params)
    end
    @orders = @q.result(distinct: true).page(params[:page])
    @orders = [] if params[:customer_name_cont].present? and @params[:user_id_in].blank?
    product_ids = PurchasedItem.where(order_id: @orders.map(&:id).uniq).pluck(:product_id) if product_ids.blank?
    @users_hash = User.where(id: @orders.map(&:user_id)).pluck(:id, :name).to_h
    @product_hash = Product.get_product_list_hash(product_ids)
  end

  private

  def current_record_params
    params.require(:good).permit!
  end 

end