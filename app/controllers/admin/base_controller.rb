class Admin::BaseController < ApplicationController
  layout "admin"

  before_action :admin_required, except: [:index]

  def index
    if cookies.signed[:admin_id].present? and Admin.where(id: cookies.signed[:admin_id]).includes(:roles).first
      redirect_to admin_home_url
    else
      render layout: false
    end
  end

  def home
    p @admin
  end

  def admin_required
    if (not cookies.signed[:admin_id]) or (not Admin.where(id: cookies.signed[:admin_id]).first.active)
      redirect_to admin_root_url
    end
    @admin = Admin.where(id: cookies.signed[:admin_id]).includes(:roles).first
  end
end