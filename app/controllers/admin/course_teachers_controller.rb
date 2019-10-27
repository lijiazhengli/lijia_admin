class Admin::CourseTeachersController < Admin::BaseController
  layout 'admin'
  before_action :get_course

  def index
    @items = @course.course_teachers.page(params[:page])
  end

  def new
    @item = @course.course_teachers.build
  end

  def create
    @item = @course.course_teachers.build(current_record_params)
    if @item.save
      redirect_to admin_course_course_teachers_path(@course)
    else
      render :new
    end
  end

  def update
    @item = CourseTeacher.find(params[:id])
    if @item.update_attributes(current_record_params)
      redirect_to admin_course_course_teachers_path(@course)
    else
      render :edit
    end
  end

  def edit
    @item = CourseTeacher.find(params[:id])
  end

  def destroy
    @item = CourseTeacher.find(params[:id])
    redirect_to admin_course_course_teachers_path(@course) if @item.destroy
  end

  private

  def current_record_params
    params.require(:course_teacher).permit!
  end

  def get_course
    @course = Course.find(params[:course_id])
  end
end