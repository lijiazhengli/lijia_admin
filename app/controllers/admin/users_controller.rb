class Admin::UsersController < Admin::BaseController
  layout 'admin'
  #before_action :get_course

  def index
    @params = params[:q] || {}
    @q = User.order('id desc').ransack(@params)
    @items = @q.result(distinct: true).page(params[:page])

   # @items = @course.students.includes(:user).page(params[:page])
  end

  private

  def current_record_params
    params.require(:student).permit!
  end

end