class Admin::IntroducesController < Admin::BaseController
  layout 'admin'
  skip_before_action :admin_required, only: [:file_upload]

  def index
    @params = params[:q] || {}
    @q = Introduce.ransack(@params)
    @items = @q.result(distinct: true).page(params[:page])
  end

  def new
    @item = Introduce.new
  end
  def create
    @item = Introduce.new(current_record_params)
    if @item.save
      redirect_to admin_introduces_path
    else
      render :new
    end
  end

  def update
    @item = Introduce.find(params[:id])
    if @item.update_attributes(current_record_params)
      redirect_to admin_introduces_path
    else
      render :edit
    end
  end

  def edit
    @item = Introduce.find(params[:id])
  end

  def destroy
    @item = Introduce.find(params[:id])
    redirect_to admin_introduces_path if @item.destroy
  end

  def file_upload
    file_upload_to_qiniu('introduces/')
  end

  private

  def current_record_params
    params.require(:introduce).permit!
  end 
end