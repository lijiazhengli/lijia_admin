class WelcomeController < ApplicationController
  def index
  	@slideshows = Introduce.web_home
  end
end
