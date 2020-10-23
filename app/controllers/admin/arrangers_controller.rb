class Admin::ArrangersController < Admin::BaseController
  layout 'admin'

  def index
    @params = params[:q] || {}
    @q = Arranger.order('active desc, orders_count desc').ransack(@params)
    @arrangers = @q.result(distinct: true).page(params[:page])
  end

  def service_orders
    @arranger = Arranger.find(params[:id])
    @params = params[:q] || {}
    @q = @arranger.orders.order('start_date desc').ransack(@params)
    @orders = @q.result(distinct: true).page(params[:page])
    @admins_hash = Admin.where(id: @orders.map(&:admin_id)).pluck(:id, :name).to_h
  end

  def new
    @arranger = Arranger.new
  end

  def create
    @arranger = Arranger.new(current_record_params)
    if @arranger.save
      redirect_to admin_arrangers_path
    else
      render :new
    end
  end

  def update
    @arranger = Arranger.find(params[:id])
    if @arranger.update_attributes(current_record_params)
      redirect_to admin_arrangers_path
    else
      render :edit
    end
  end

  def edit
    @arranger = Arranger.find(params[:id])
  end

  private

  def current_record_params
    params.require(:arranger).permit!
  end 

end