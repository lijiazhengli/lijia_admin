class Admin::AdminController < Admin::BaseController
  layout 'admin'
  skip_before_action :admin_required, only: [:do_login]
  skip_before_action :verify_authenticity_token, only: [:do_login]


  def index
    @admins = Admin.all.page params[:page]
  end

  def ha1(name, realm, password)
    Digest::MD5.hexdigest([name, realm, password].join(':'))
  end

  def edit
  end

  def update
    p params
    admin = Admin.find(params[:id])
    password = params[:password].strip
    if password == params[:password_confirmation].strip and admin.update_attributes(password_hash: ha1(admin.name, 'Lijia', password))
      flash[:edit_password_error] = nil
      redirect_to admin_home_url
    else
      flash[:edit_password_error] = '两次输入不一致'
      render :edit
    end
  end

  def do_login
    name = params[:name]
    password = params[:password]
    redirect_url = params[:redirect_url]
    admin = Admin.find_by_name(name)
    password_hash = ha1(name, 'Lijia', password)

    # TODO should use can?(:login, @city) here
    if admin
      if admin.password_hash == password_hash
        cookies.signed[:admin_id] = admin.id
        @admin = admin

        if redirect_url
          redirect_to redirect_url
        else
          redirect_to admin_home_url
        end
      else
        redirect_to admin_root_path
      end
    else
      redirect_to admin_root_path
    end
  end

  def do_logout
    cookies.signed[:admin_id] = nil       # so the app knows
    redirect_to admin_root_path
  end
end