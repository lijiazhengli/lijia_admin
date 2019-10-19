class Admin::CoursesController < Admin::BaseController
  layout 'admin'
  skip_before_action :admin_required, only: [:file_upload]

  def index
    @params = params[:q] || {}
    @q = Course.ransack(@params)
    @courses = @q.result(distinct: true).page(params[:page])
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(current_record_params)
    if @course.save
      redirect_to admin_courses_path
    else
      render :new
    end
  end

  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(current_record_params)
      redirect_to admin_courses_path
    else
      render :edit
    end
  end

  def edit
    @course = Course.find(params[:id])
  end

  def destroy
    @course = Course.find(params[:id])
    redirect_to :back if @course.destroy
  end

  def file_upload
    file_upload_to_qiniu('course-')
  end

  private

  def current_record_params
    params.require(:course).permit!
  end 

end