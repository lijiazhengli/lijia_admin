namespace :arranger do
  desc '学员导入为整理师'
  task :init => :environment do
  	Arranger.destroy_all
    User.where.not(status: 1, name: nil).each do |user|
      item = Arranger.where(name: user.name, phone_number: user.phone_number).first_or_create
      item.update(active: true)
    end
  end