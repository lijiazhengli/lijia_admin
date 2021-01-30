class Admin::CourseCityInfosController < Admin::BaseController
  layout 'admin'
  before_action :get_course
  #before_action :admin_senior_stockholder_required, only: [:index, :new, :create, :update, :edit, :destroy]

  def index
    @params = params[:q] || {}
    @q = @course.course_city_infos.order('active desc,position').ransack(@params)
    @items = @q.result(distinct: true).page(params[:page]).per(100)
  end

  def new
    @item = @course.course_city_infos.build
  end

  def create
    @item = @course.course_city_infos.build(current_record_params)
    if @item.save
      redirect_to admin_course_course_city_infos_path(@course)
    else
      render :new
    end
  end

  def update
    @item = @course.course_city_infos.find(params[:id])
    if @item.update_attributes(current_record_params)
      redirect_to admin_course_course_city_infos_path(@course)
    else
      render :edit
    end
  end

  def edit
    @item = @course.course_city_infos.find(params[:id])
  end

  def destroy
    @item = @course.course_city_infos.find(params[:id])
    @item.destroy
    redirect_to admin_course_course_city_infos_path(@course)
  end


  def up_serial
    item = CourseCityInfo.where(id: params[:id]).first
    if item.up_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  def down_serial
    item = CourseCityInfo.where(id: params[:id]).first
    if item.down_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  def date_position
    @course.course_city_infos.order('date_info asc').each_with_index do |item, index|
      item.update(position: index)
    end
    redirect_to admin_course_course_city_infos_path(@course), notice: '成功'
  end

  def enable
    item = CourseCityInfo.find(params[:id])
    if item.enable
      redirect_to admin_course_course_city_infos_path(@course), notice: '成功'
    else
      redirect_to admin_course_course_city_infos_path(@course), alert: '失败'
    end
  end

  def disable
    item = CourseCityInfo.find(params[:id])
    if item.disable
      redirect_to admin_course_course_city_infos_path(@course), notice: '成功'
    else
      redirect_to admin_course_course_city_infos_path(@course), alert: '失败'
    end
  end


  private

  def current_record_params
    params.require(:course_city_info).permit!
  end

  def get_course
    @course = Course.find(params[:course_id])
  end
end