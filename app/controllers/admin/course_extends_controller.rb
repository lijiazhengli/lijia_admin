class Admin::CourseExtendsController < Admin::BaseController
  layout 'admin'
  before_action :get_course
  before_action :admin_senior_stockholder_required, only: [:index, :new, :create, :update, :edit, :destroy]

  def index
    item = @course.self_extend
    redirect_to edit_admin_course_course_extend_path(@course, item)
  end

  def update
    @item = CourseExtend.find(params[:id])
    if @item.update_attributes(current_record_params)
      redirect_to admin_courses_path
    else
      render :edit
    end
  end

  def edit
    @item = CourseExtend.find(params[:id])
  end

  private

  def current_record_params
    params.require(:course_extend).permit!
  end

  def get_course
    @course = Course.find(params[:course_id])
  end
end