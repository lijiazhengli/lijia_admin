class WelcomeController < ApplicationController
  def index
  	@slideshows = Introduce.web_home
  	products = Product.active
  	@services = products.select{|item| item.type == 'Service'}
  	@courses = products.select{|item| item.type == 'Courses'}
  end
end
