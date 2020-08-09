class CasesController < ApplicationController
  def index
  	@items = Case.active.order(:position)
  end
end