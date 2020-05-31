class WelcomeController < ApplicationController
  def index
  	@slideshows = Introduce.web_home
  	@services = Service.active
  	p @services
  end
end
