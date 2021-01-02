class CourseExtend < ApplicationRecord
  audited
  belongs_to :course

  def city_infos_list
    result = {}
    if self.city_and_date.present?
      JSON.parse(self.city_and_date).each do |city_name, date_info|
        result[city_name] = date_info.split(';')
      end
    end
    result
  end

  def city_address_info_list
    result = {}
    if self.city_and_address.present?
      result = JSON.parse(self.city_and_address)
    end
    result
  end
end
