module Admin::BaseHelper
  def active_chinese_name(info)
    info.active.present? ? '是' : '否'
  end
end