namespace :admin do 
 desc '建立后台管理账户'
  task :init_admin => :environment do
    realm = "Lijia"
    password = "lijia99"
    ActiveRecord::Base.transaction do
      { 
        admin_owner: '管理员',
        senior_stockholder: '股东'
      }.each do |role_name, description|
        Role.where(name: role_name, description: description).first_or_create
      end
      role = Role.find_by_name('senior_stockholder')
      {
        'tangling' => '唐玲',
        'changli' => '常莉',
        'liuxue' => '刘薛',
        'yueyanxia' => '岳艳霞',
        'bolei' => '薄蕾',
        'zhangwei' => '张维',
        'linxuefeng' => '林雪枫',
        'jiaoyuxin' => '焦雨欣'

      }.each do |name, user_name|
        admin = Admin.find_by_name(name)
        if admin.blank?
          p_hash = Digest::MD5.hexdigest([name, realm, password].join(':'))
          admin = Admin.create!(name: name, password_hash: p_hash, active: true, user_name: user_name)
          admin.role_assignments.create!(role_id: role.id)
        end
      end
    end

    '常莉、刘薛（晓雪）、岳艳霞、薄蕾（蕾蕾）、张维、林雪枫、刘素芬、马卓、陈子奇、何娅楠、仲昭秋、董彬、孙燕、国艳琴、孙芳媛'.split('、').each do |user_name|
      arranger = Arranger.where(name: user_name).first_or_create
      arranger.update_attributes(base_order_count: 999)
    end

    '江红、马欣、马倩'.split('、').each do |user_name|
      arranger = Arranger.where(name: user_name).first_or_create
      arranger.update_attributes(base_order_count: 8)
    end

    '刘岩、张华、李秀桂、田甜、宋云香、姚桂杰'.split('、').each do |user_name|
      arranger = Arranger.where(name: user_name).first_or_create
      arranger.update_attributes(base_order_count: 2)
    end
    '棚桥丽华、王艳杰、郭锐、张颖'.split('、').each do |user_name|
      arranger = Arranger.where(name: user_name).first_or_create
      arranger.update_attributes(base_order_count: 1)
    end

  end
end