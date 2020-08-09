class Admin::CasesController < Admin::BaseController
  layout 'admin'
  skip_before_action :admin_required, only: [:file_upload]

  def index
    @params = params[:q] || {}
    @q = Case.order('active desc, position asc').ransack(@params)
    @items = @q.result(distinct: true).page(params[:page])
  end

  def new
    @item = Case.new
  end
  def create
    @item = Case.new(current_record_params)
    if @item.save
      redirect_to admin_cases_path
    else
      render :new
    end
  end

  def update
    @item = Case.find(params[:id])
    if @item.update_attributes(current_record_params)
      redirect_to admin_cases_path
    else
      render :edit
    end
  end

  def edit
    @item = Case.find(params[:id])
  end

  def destroy
    @item = Case.find(params[:id])
    redirect_to admin_cases_path if @item.destroy
  end

  def file_upload
    file_upload_to_qiniu('cases')
  end

  def up_serial
    item = Case.where(id: params[:id]).first
    if item.up_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  def down_serial
    item = Case.where(id: params[:id]).first
    if item.down_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  def enable
    item = Case.find(params[:id])
    if item.enable
      redirect_to admin_cases_path, notice: '成功'
    else
      redirect_to admin_cases_path, alert: '失败'
    end
  end

  def disable
    item = Case.find(params[:id])
    if item.disable
      redirect_to admin_cases_path, notice: '成功'
    else
      redirect_to admin_cases_path, alert: '失败'
    end
  end

  private

  def current_record_params
    params.require(:case).permit!
  end 
end