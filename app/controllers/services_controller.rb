class ServicesController < ApplicationController
  def index
  	@ad_image = AdImage.where(ad_type: "web_service", active: true).last
  end
  def show
    p params
    @product = Service.find(params[:id])
    @other_products = Service.active.where.not(id: params[:id])
  end
end