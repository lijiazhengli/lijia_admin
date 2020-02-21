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
      redirect_to admin_goods_path, alert: '成功'
    else
      redirect_to admin_goods_path, alert: '失败'
    end
  end

  def disable
    item = Good.find(params[:id])
    if item.disable
      redirect_to admin_goods_path, alert: '成功'
    else
      redirect_to admin_goods_path, alert: '失败'
    end
  end

  def order
    product_ids = params[:product_ids].present? ? params[:product_ids].split(',') : []
    @params = params[:q] || {}
    if product_ids.present?
      @q = Order.noncanceled.includes(:purchased_items).where(purchased_items: {product_id: product_ids}).order('orders.id desc').ransack(@params)
    else
      @q = Order.noncanceled.order('orders.id desc').ransack(@params)
    end
    @orders = @q.result(distinct: true).page(params[:page])
  end

  private

  def current_record_params
    params.require(:good).permit!
  end 

end