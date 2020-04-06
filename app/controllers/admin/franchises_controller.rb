class Admin::FranchisesController < Admin::BaseController
  layout 'admin'
  skip_before_action :admin_required, only: [:file_upload, :up_serial, :down_serial]
  before_action :admin_senior_stockholder_required, only: [:index, :new, :create, :update, :edit]

  def index
    @params = params[:q] || {}
    @q = Franchise.order('active desc, position asc').ransack(@params)
    @items = @q.result(distinct: true).page(params[:page])
  end

  def new
    @item = Franchise.new
  end

  def create
    @item = Franchise.new(current_record_params)
    if @item.save
      @item.self_extend.update(address: params[:course_address])
      redirect_to admin_franchises_path
    else
      render :new
    end
  end

  def show
    @item = Franchise.find(params[:id])
  end

  def update
    @item = Franchise.find(params[:id])
    if @item.update_attributes(current_record_params)
      redirect_to admin_franchises_path
    else
      render :edit
    end
  end

  def edit
    @item = Franchise.find(params[:id])
  end

  def file_upload
    file_upload_to_qiniu('franchise')
  end
  def up_serial
    item = Franchise.where(id: params[:id]).first
    if item.up_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  def down_serial
    item = Franchise.where(id: params[:id]).first
    if item.down_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  def enable
    item = Franchise.find(params[:id])
    if item.enable
      redirect_to admin_franchises_path, alert: '成功'
    else
      redirect_to admin_franchises_path, alert: '失败'
    end
  end

  def disable
    item = Franchise.find(params[:id])
    if item.disable
      redirect_to admin_franchises_path, alert: '成功'
    else
      redirect_to admin_franchises_path, alert: '失败'
    end
  end

  private

  def current_record_params
    params.require(:franchise).permit!
  end 

end