class CourseExtend < ApplicationRecord
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
end
