class Admin::ServicesController < Admin::BaseController
  layout 'admin'
  skip_before_action :admin_required, only: [:file_upload]

  def index
    @params = params[:q] || {}
    @q = Service.order('active desc, position asc').ransack(@params)
    @items = @q.result(distinct: true).page(params[:page])
  end

  def new
    @service = Service.new
  end

  def create
    @service = Service.new(current_record_params)
    if @service.save
      redirect_to admin_services_path
    else
      render :new
    end
  end

  def update
    @service = Service.find(params[:id])
    if @service.update_attributes(current_record_params)
      redirect_to admin_services_path
    else
      render :edit
    end
  end

  def edit
    @service = Service.find(params[:id])
  end

  def destroy
    @service = Service.find(params[:id])
    redirect_to :back if @service.destroy
  end

  def file_upload
    file_upload_to_qiniu('service')
  end

  def up_serial
    item = Service.where(id: params[:id]).first
    if item.up_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  def down_serial
    item = Service.where(id: params[:id]).first
    if item.down_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  def enable
    item = Service.find(params[:id])
    if item.enable
      redirect_to admin_services_path, notice: '成功'
    else
      redirect_to admin_services_path, alert: '失败'
    end
  end

  def disable
    item = Service.find(params[:id])
    if item.disable
      redirect_to admin_services_path, notice: '成功'
    else
      redirect_to admin_services_path, alert: '失败'
    end
  end

  private

  def current_record_params
    params.require(:service).permit!
  end 

end