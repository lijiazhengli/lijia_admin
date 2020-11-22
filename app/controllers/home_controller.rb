class HomeController < ApplicationController
  def index
    @slideshows = Introduce.web_home
    products = Product.active
    @services = products.select{|item| item.type == 'Service'}
    @courses = products.select{|item| item.type == 'Course'}
    @courses_extends = CourseExtend.where(course_id: @courses.map(&:id))
    @goods = products.select{|item| item.type == 'Good'}
    @good_sets = ProductSet.where(id: @goods.map(&:product_set_id).uniq)
  end

  def info
    web_info  = Introduce.web_info
    @info = web_info.select{|i| i.item_type == 'home_info'}.first
    @franchise = web_info.select{|i| i.item_type == 'franchise'}.first
    @teams = Introduce.active_team
    @teachers = Teacher.current_active
  end
end