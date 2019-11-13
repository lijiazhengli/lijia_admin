class Admin::GoodsController < Admin::BaseController
  layout 'admin'
  skip_before_action :admin_required, only: [:file_upload]

  def index
    @params = params[:q] || {}
    @q = Good.ransack(@params)
    @goods = @q.result(distinct: true).page(params[:page])
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

  private

  def current_record_params
    params.require(:good).permit!
  end 

end