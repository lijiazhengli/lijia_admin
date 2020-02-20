class Admin::CoursesController < Admin::BaseController
  layout 'admin'
  skip_before_action :admin_required, only: [:file_upload]

  def index
    @params = params[:q] || {}
    @q = Course.order('active desc, position asc').ransack(@params)
    @items = @q.result(distinct: true).page(params[:page])
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(current_record_params)
    if @course.save
      @course.self_extend.update(address: params[:course_address])
      redirect_to admin_courses_path
    else
      render :new
    end
  end

  def show
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(current_record_params)
      @course.self_extend.update(address: params[:course_address])
      redirect_to admin_courses_path
    else
      render :edit
    end
  end

  def edit
    @course = Course.find(params[:id])
    params[:course_address] = @course.self_extend.address
  end

  def destroy
    @course = Course.find(params[:id])
    redirect_back(fallback_location: admin_courses_path) if @course.destroy
  end

  def order
    @course = Course.find(params[:id])
    @params = params[:q] || {}
    @q = Order.noncanceled.includes(:purchased_items).where(purchased_items: {product_id: @course.id}).order('orders.id desc').ransack(@params)
    @orders = @q.result(distinct: true).page(params[:page])
  end

  def file_upload
    file_upload_to_qiniu('course')
  end
  def up_serial
    item = Course.where(id: params[:id]).first
    if item.up_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  def down_serial
    item = Course.where(id: params[:id]).first
    if item.down_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  def enable
    item = Course.find(params[:id])
    if item.enable
      redirect_to admin_courses_path, alert: '成功'
    else
      redirect_to admin_courses_path, alert: '失败'
    end
  end

  def disable
    item = Course.find(params[:id])
    if item.disable
      redirect_to admin_courses_path, alert: '成功'
    else
      redirect_to admin_courses_path, alert: '失败'
    end
  end

  private

  def current_record_params
    params.require(:course).permit!
  end 

end