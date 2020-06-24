class CoursesController < ApplicationController
  def index
  end
  def show
    @product = Course.find(params[:id])
    @other_products = Course.active.where.not(id: params[:id])
    @product_extend = @product.course_extend
  end
end