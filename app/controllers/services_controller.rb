class ServicesController < ApplicationController
  def index
  end
  def show
    p params
    @product = Service.find(params[:id])
  end
end