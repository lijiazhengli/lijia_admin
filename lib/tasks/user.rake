namespace :user do
  desc '初始化用户，course_extends.has_student_zhekou 是true,并且该用户有成功的订单purchased_items.product_id 状态已完成，给该用户打标签'
  task :current_user_role => :environment do
    Role.includes(:admins).each do |role|
      role.admins.each do |item|
        puts [role.description, item.user_name, item.name].join(',')
      end
    end
  end
end