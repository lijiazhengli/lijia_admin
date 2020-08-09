class Admin::TeachersController < Admin::BaseController
  layout 'admin'

  def index
    @params = params[:q] || {}
    @q = Teacher.order('active desc, position asc').ransack(@params)
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
    file_upload_to_qiniu('teacher')
  end

  def up_serial
    item = Teacher.where(id: params[:id]).first
    if item.up_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  def down_serial
    item = Teacher.where(id: params[:id]).first
    if item.down_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  private

  def current_record_params
    params.require(:teacher).permit!
  end 

end