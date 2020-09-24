class Admin::AppliesController < Admin::BaseController
  layout 'admin'

  def index
    @items, @params, @q = Apply.search_result(params)
    @items = @q.result(distinct: true).page(params[:page])
    @users_hash = User.where(id: @items.map(&:user_id)).map{|u| [u.id, u]}.to_h
    @admins_hash = Admin.where(id: @items.map(&:admin_id)).pluck(:id, :name).to_h
  end

  def update
    @item = Apply.find(params[:id])
    @item.admin_id = @admin.id
    if @item.update_attributes(current_record_params)
      redirect_to admin_applies_path
    else
      render :edit
    end
  end

  def edit
    @item = Apply.find(params[:id])
  end


  def update_status
    item = Apply.find(params[:id])
    if item.update_attributes(status: params[:status])
      redirect_back(fallback_location: admin_applies_path, notice: '成功')
    else
      redirect_back(fallback_location: admin_applies_path, alert: '失败')
    end
  end

  def completed
    item = Apply.find(params[:id])
    if item.do_completed
      redirect_back(fallback_location: admin_applies_path, notice: '成功')
    else
      redirect_back(fallback_location: admin_applies_path, alert: '失败')
    end
  end

  def canceled
    item = Apply.find(params[:id])
    if item.do_canceled
      redirect_back(fallback_location: admin_applies_path, notice: '成功')
    else
      redirect_back(fallback_location: admin_applies_path, alert: '失败')
    end
  end

  private

  def current_record_params
    params.require(:apply).permit!
  end 

end