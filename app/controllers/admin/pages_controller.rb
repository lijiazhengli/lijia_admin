class Admin::PagesController < Admin::BaseController
  layout 'admin'

  def index
    @params = params[:q] || {}
    @q = Page.ransack(@params)
    @items = @q.result(distinct: true).page(params[:page])
  end

  def new
    @item = Page.new
  end
  def create
    @item = Page.new(current_record_params)
    if @item.save
      redirect_to admin_pages_path
    else
      render :new
    end
  end

  def update
    @item = Page.find(params[:id])
    if @item.update_attributes(current_record_params)
      redirect_to admin_pages_path
    else
      render :edit
    end
  end

  def edit
    @item = Page.find(params[:id])
  end

  def destroy
    @item = Page.find(params[:id])
    redirect_to admin_pages_path if @item.destroy
  end

  private

  def current_record_params
    params.require(:page).permit!
  end 
end