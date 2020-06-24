class ServicesController < ApplicationController
  def index
  end
  def show
    p params
    @product = Service.find(params[:id])
    @other_products = Service.active.where.not(id: params[:id])
  end
end