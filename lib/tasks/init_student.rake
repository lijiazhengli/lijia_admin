namespace :student do 
  desc '更新学员信息'
  task :init_student => :environment do
    Student.where(phone_number: nil).each do |item|
      user = item.user
      item.update_attributes(name: item.order.try(:customer_name), phone_number: user.phone_number)
    end
  end
end