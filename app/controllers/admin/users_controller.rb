class Admin::UsersController < Admin::BaseController
  layout 'admin'
  #before_action :get_course

  def index
    @params = params[:q] || {}
    @q = User.order('id desc').ransack(@params)
    @items = @q.result(distinct: true).page(params[:page])

   # @items = @course.students.includes(:user).page(params[:page])
  end

  def update
    @item = User.find(params[:id])
    if @item.update_attributes(current_record_params)
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def edit
    @item = User.find(params[:id])
  end

  private

  def current_record_params
    params.require(:user).permit!
  end

end