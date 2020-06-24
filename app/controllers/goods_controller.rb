class GoodsController < ApplicationController
  def index
  end
  def show
    @product = Good.find(params[:id])
    @other_products = Good.active.where.not(id: params[:id])
  end
end