class Admin::ServicesController < Admin::BaseController
  layout 'admin'
  skip_before_action :admin_required, only: [:file_upload]

  def index
    @params = params[:q] || {}
    @q = Service.ransack(@params)
    @services = @q.result(distinct: true).page(params[:page])
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
    file_upload_to_qiniu('service-')
  end

  private

  def current_record_params
    params.require(:service).permit!
  end 

end