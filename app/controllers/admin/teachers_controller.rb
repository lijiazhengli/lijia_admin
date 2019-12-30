class Admin::TeachersController < Admin::BaseController
  layout 'admin'

  def index
    @params = params[:q] || {}
    @q = Teacher.ransack(@params)
    @items = @q.result(distinct: true).page(params[:page])
  end

  def new
    @item = Teacher.new
  end

  def create
    @item = Teacher.new(current_record_params)
    if @item.save
      redirect_to admin_teachers_path
    else
      render :new
    end
  end

  def update
    @item = Teacher.find(params[:id])
    if @item.update_attributes(current_record_params)
      redirect_to admin_teachers_path
    else
      render :edit
    end
  end

  def edit
    @item = Teacher.find(params[:id])
  end

  def file_upload
    file_upload_to_qiniu('teacher/')
  end

  private

  def current_record_params
    params.require(:teacher).permit!
  end 

end