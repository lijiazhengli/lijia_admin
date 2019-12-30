class Address < ApplicationRecord
  scope :for_user, -> (user_id) {where(user_id: user_id).order('updated_at desc')}

  def get_is_default
    self.is_default ? 1 : 0
  end

  def get_applet_sex
    self.sex ? "#{self.sex}" : '0'
  end

  def to_cart_info
    attrs = {}
    attrs[:address_id] =  self.id
    %w(location_title recipient_name recipient_phone_number location_address location_details
      gaode_lng gaode_lat address_province address_city address_district).each do |info|
      attrs[info.to_sym] =  self.send(info)
    end
    attrs[:is_default] = self.get_is_default
    attrs[:sex] = self.get_applet_sex
    attrs
  end


  def to_applet_order_info
    attrs = {}
    %w(location_title recipient_name recipient_phone_number location_address location_details
      address_province address_city address_district).each do |info|
      attrs[info.to_sym] =  self.send(info)
    end
    attrs[:sex] = self.get_applet_sex
    attrs
  end
end
