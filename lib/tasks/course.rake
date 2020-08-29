namespace :course do 
  desc '更新课程城市信息'
  task :init_city_info => :environment do
    CourseExtend.where(show_city_list: true).each do |item|
      city_address_info_list = item.city_address_info_list
      item.city_infos_list.each do |city_name, dates|
        dates.each do |date_info|
          info = CourseCityInfo.where(course_id: item.course_id, city_name: city_name, date_info: date_info).first_or_create
          info.update(address: city_address_info_list[city_name], active: true)
        end
      end
    end
  end
end