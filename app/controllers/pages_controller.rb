class PagesController < ApplicationController
  def show
    @item = Page.find_by_url(params[:id])
  end
end