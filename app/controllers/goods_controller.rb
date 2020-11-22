class GoodsController < ApplicationController
  def index
  end
  def show
    @product = Good.find(params[:id])
    @set = @product.product_set
    @other_products = Good.active.where.not(id: params[:id])
    @good_sets = ProductSet.where(id: @other_products.map(&:product_set_id).uniq)
  end
end