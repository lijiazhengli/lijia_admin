module ControllerHelpers
  # 需要登录后台用户的地方，请先执行sign_in_admin!登录，用户为admin权限
  def sign_in_admin!
    @admin = create(:admin)
    cookies.signed[:admin_id] = @admin.id
  end

  def admin_logout!
    cookies.signed[:admin_id] = nil
  end
end
