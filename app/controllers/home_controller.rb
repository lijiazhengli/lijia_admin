class HomeController < ApplicationController
  def index
    @slideshows = Introduce.web_home
    products = Product.active
    @services = products.select{|item| item.type == 'Service'}
    @courses = products.select{|item| item.type == 'Course'}
    @goods = products.select{|item| item.type == 'Good'}
  end

  def info
    web_info  = Introduce.web_info
    @info = web_info.select{|i| i.item_type == 'home_info'}.first
    @franchise = web_info.select{|i| i.item_type == 'franchise'}.first
    @teams = Introduce.active_team
    @teachers = Teacher.current_active
  end
end