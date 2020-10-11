module Admin::BaseHelper
  def active_chinese_name(info)
    info.active.present? ? '是' : '否'
  end

  def show_active_chinese_name(info)
    info ? '是' : '否'
  end

  def show_referral_info(item, info)
    arr = []
    arr << item.referral_name if item.referral_name.present?
    if item.referral_phone_number.present?
      arr << item.referral_phone_number
      user = info[item.referral_phone_number]
      arr << user.show_status if user.present?
    end
    arr.join('|')
  end

  def show_organizer_info(item, info)
    arr = []
    arr << item.organizer_name if item.organizer_name.present?
    if item.organizer_phone_number.present?
      arr << item.organizer_phone_number
      user = info[item.organizer_phone_number]
      arr << user.show_status if user.present?
    end
    arr.join('|')
  end

end