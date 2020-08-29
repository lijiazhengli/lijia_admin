namespace :role do 
  desc '权限信息'
  task :current_user_role => :environment do
    Role.includes(:admins).each do |role|
      role.admins.each do |item|
        puts [role.description, item.user_name, item.name].join(',')
      end
    end
  end
end