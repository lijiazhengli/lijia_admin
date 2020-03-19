module Admin::BaseHelper
  def active_chinese_name(info)
    info.active.present? ? '是' : '否'
  end

  def show_active_chinese_name(info)
    info ? '是' : '否'
  end
end