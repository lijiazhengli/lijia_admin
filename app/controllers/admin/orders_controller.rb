class Admin::OrdersController < Admin::BaseController
  layout 'admin'

  def index
    p params
    @params = params[:q] || {}
    @q = Order.order('id desc').ransack(@params)
    @orders = @q.result(distinct: true).page(params[:page])
    @admins_hash = Admin.where(id: @orders.map(&:admin_id)).pluck(:id, :name).to_h
  end

  def new
    @order = Order.new(admin_id: @admin.id)
  end

  def create
    @order = Order.new(current_record_params)
    if @order.save
      redirect_to admin_orders_path
    else
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])
    @order_arranger_assignments = @order.order_arranger_assignments
    @arrangers_hash = Arranger.where(id: @order_arranger_assignments.map(&:arranger_id)).pluck(:id, :name).to_h
  end

  def update
    @order = Order.find(params[:id])
    if @order.update_attributes(current_record_params)
      redirect_to admin_orders_path
    else
      render :edit
    end
  end

  def edit
    @order = Order.find(params[:id])
  end


  private

  def current_record_params
    params.require(:order).permit!
  end 

end