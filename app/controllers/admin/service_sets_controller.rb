class Admin::ServiceSetsController < Admin::BaseController
  layout 'admin'
  skip_before_action :admin_required, only: [:file_upload]

  def index
    @params = params[:q] || {}
    @q = ServiceSet.order('active desc, position asc').ransack(@params)
    @items = @q.result(distinct: true).page(params[:page])
    @products = Product.active.where(product_set_id: @items.map(&:id))
  end

  def new
    @item = ServiceSet.new
  end

  def create
    @item = ServiceSet.new(current_record_params)
    if @item.save
      redirect_to admin_service_sets_path
    else
      render :new
    end
  end

  def update
    @item = ServiceSet.find(params[:id])
    if @item.update_attributes(current_record_params)
      redirect_to admin_service_sets_path
    else
      render :edit
    end
  end

  def edit
    @item = ServiceSet.find(params[:id])
  end


  def file_upload
    file_upload_to_qiniu('good_set')
  end

  def up_serial
    item = ServiceSet.where(id: params[:id]).first
    if item.up_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  def down_serial
    item = ServiceSet.where(id: params[:id]).first
    if item.down_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  def enable
    item = ServiceSet.find(params[:id])
    if item.enable
      redirect_to admin_service_sets_path, notice: '成功'
    else
      redirect_to admin_service_sets_path, alert: '失败'
    end
  end

  def disable
    item = ServiceSet.find(params[:id])
    if item.disable
      redirect_to admin_service_sets_path, notice: '成功'
    else
      redirect_to admin_service_sets_path, alert: '失败'
    end
  end


  private

  def current_record_params
    params.require(:service_set).permit!
  end 

end