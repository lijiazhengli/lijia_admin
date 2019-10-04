namespace :admin do 
 desc '建立后台管理账户'
  task :init_admin => :environment do
    realm = "Lijia"
    password = "lijia000"
    ActiveRecord::Base.transaction do
      { 
        admin_owner: '管理员'
      }.each do |role_name, description|
        Role.where(name: role_name, description: description).first_or_create
      end
      {'tangling' => 'tl123'}.each do |name, password|
        admin = Admin.find_by_name(name)
        if admin.blank?
          p_hash = Digest::MD5.hexdigest([name, realm, password].join(':'))
          admin = Admin.create!(name: name, password_hash: p_hash, active: true)
          admin.role_assignments.create!(role: Role.find_by_name('admin_owner'))
        end
      end
    end
  end
end