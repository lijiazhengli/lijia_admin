class Admin::AdImagesController < Admin::BaseController
  layout 'admin'
  skip_before_action :admin_required, only: [:file_upload]

  def index
    @params = params[:q] || {}
    @q = AdImage.ransack(@params)
    @items = @q.result(distinct: true).page(params[:page])
  end

  def new
    @item = AdImage.new
  end
  def create
    @item = AdImage.new(current_record_params)
    if @item.save
      redirect_to admin_ad_images_path
    else
      render :new
    end
  end

  def update
    @item = AdImage.find(params[:id])
    if @item.update_attributes(current_record_params)
      redirect_to admin_ad_images_path
    else
      render :edit
    end
  end

  def edit
    @item = AdImage.find(params[:id])
  end

  def destroy
    @item = AdImage.find(params[:id])
    redirect_to admin_ad_images_path if @item.destroy
  end

  def file_upload
    file_upload_to_qiniu('ad_image')
  end

  private

  def current_record_params
    params.require(:ad_image).permit!
  end 
end