class Admin::OrderArrangerAssignmentsController < Admin::BaseController
  layout 'admin'
  before_action :get_order

  def index
    @items = @order.order_arranger_assignments.page(params[:page])
    @arrangers_hash = Arranger.where(id: @items.map(&:arranger_id)).pluck(:id, :name).to_h
  end

  def new
    @item = @order.order_arranger_assignments.build(order_type: @order.order_type)
  end

  def create
    @item = @order.order_arranger_assignments.build(current_record_params)
    if @item.save
      redirect_to admin_order_order_arranger_assignments_path(@order)
    else
      render :new
    end
  end

  def update
    @item = OrderArrangerAssignment.find(params[:id])
    if @item.update_attributes(current_record_params)
      redirect_to admin_order_order_arranger_assignments_path(@order)
    else
      render :edit
    end
  end

  def edit
    @item = OrderArrangerAssignment.find(params[:id])
  end

  def destroy
    @item = OrderArrangerAssignment.find(params[:id])
    redirect_to admin_order_order_arranger_assignments_path(@order) if @item.destroy
  end

  private

  def current_record_params
    params.require(:order_arranger_assignment).permit!
  end

  def get_order
    @order = Order.find(params[:order_id])
  end
end