class Admin::StudentsController < Admin::BaseController
  layout 'admin'
  #before_action :get_course

  def index
    @params = params[:q] || {}
    if params[:course_id].present?
      @params[:course_id_eq] = params[:course_id]
    end
    if params[:phone_number].present?
      user_id = User.ransack({phone_number_cont: params[:phone_number]}).result(distinct: true).pluck(:id).uniq
      @q = Student.where(user_id: user_id).order('id desc').includes(:user, :course).ransack(@params)
    else
      @q = Student.order('id desc').includes(:user, :course).ransack(@params)
    end
    @items = @q.result(distinct: true).page(params[:page])

   # @items = @course.students.includes(:user).page(params[:page])
  end

  def update
    @item = Student.find(params[:id])
    if @item.update_attributes(current_record_params)
      #redirect_to admin_course_students_path(@course)
      redirect_to admin_students_path(@course)
    else
      render :edit
    end
  end

  def edit
    @item = Student.find(params[:id])
  end

  private

  def current_record_params
    params.require(:student).permit!
  end

  def get_course
    @course = Course.find(params[:course_id])
  end
end