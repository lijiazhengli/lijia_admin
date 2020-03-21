class Admin::ProductsController < Admin::BaseController
  layout 'admin'

  def index
    p params
    @params = params[:q] || {}
    @q = Product.order('id desc').ransack(@params)
    @items = @q.result(distinct: true).page(params[:page])
  end
end