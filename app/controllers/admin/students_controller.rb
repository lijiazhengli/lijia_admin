class Admin::StudentsController < Admin::BaseController
  layout 'admin'
  before_action :get_course

  def index
    @items = @course.students.includes(:user).page(params[:page])
  end

  def update
    @item = Student.find(params[:id])
    if @item.update_attributes(current_record_params)
      redirect_to admin_course_students_path(@course)
    else
      render :edit
    end
  end

  def edit
    @item = Student.find(params[:id])
  end

  def destroy
    @item = Student.find(params[:id])
    redirect_to admin_course_students_path(@course) if @item.destroy
  end

  private

  def current_record_params
    params.require(:student).permit!
  end

  def get_course
    @course = Course.find(params[:course_id])
  end
end