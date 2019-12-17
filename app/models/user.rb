class User < ApplicationRecord
  has_many  :orders

  def self.find_or_create_source_user(mobile, source, user_info)
    user = User.where(phone_number: mobile).first
    return user if user.present?
    user_attr = {phone_number: mobile, source: source }
    [:wx_union_id, :wx_ma_id].each {|v| user_attr[v] = user_info[v] if user_info[v].present?}
    User.create!(user_attr)
  end

end