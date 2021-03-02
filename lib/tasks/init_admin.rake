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
      arranger.update_attributes(base_order_count: 999, active: true)
    end

    '江红、马欣、马倩'.split('、').each do |user_name|
      arranger = Arranger.where(name: user_name).first_or_create
      arranger.update_attributes(base_order_count: 8, active: true)
    end

    '刘岩、张华、李秀桂、田甜、宋云香、姚桂杰'.split('、').each do |user_name|
      arranger = Arranger.where(name: user_name).first_or_create
      arranger.update_attributes(base_order_count: 2, active: true)
    end
    '棚桥丽华、王艳杰、郭锐、张颖'.split('、').each do |user_name|
      arranger = Arranger.where(name: user_name).first_or_create
      arranger.update_attributes(base_order_count: 1, active: true)
    end

  end

  desc '更新整理师信息'
  task :update_arranger_orders_count => :environment do
    Arranger.all.each do |item|
      orders_count = OrderArrangerAssignment.where(arranger_id: item.id, order_type: Order::SERVICE_ORDER).select('distinct order_id').count
      item.update_attributes(orders_count: (item.base_order_count + orders_count))
    end
  end

  desc '更新整理师信息'
  task :init_role_200321 => :environment do
    { 
      admin_customer_service: '客服',
    }.each do |role_name, description|
      Role.where(name: role_name, description: description).first_or_create
    end
  end

  desc '更新整理师信息'
  task :init_role_200419 => :environment do
    { 
      senior_accounting: '财务',
    }.each do |role_name, description|
      Role.where(name: role_name, description: description).first_or_create
    end

    role = Role.find_by_name('senior_accounting')

    {
      'tangling' => '唐玲',
      'bolei' => '薄蕾',
      'jiaoyuxin' => '焦雨欣'

    }.each do |name, user_name|
      admin = Admin.find_by_name(name)
      if admin.present?
        admin.role_assignments.create!(role_id: role.id)
      end
    end
  end

  desc '更新整理师信息'
  task :init_admin_200321 => :environment do
    realm = "Lijia"
    password = "lijia99"
    role = Role.find_by_name('admin_customer_service')
    {
      'xiaoli' => '肖莉',
      'guohongxia' => '郭红霞'

    }.each do |name, user_name|
      admin = Admin.find_by_name(name)
      if admin.blank?
        p_hash = Digest::MD5.hexdigest([name, realm, password].join(':'))
        admin = Admin.create!(name: name, password_hash: p_hash, active: true, user_name: user_name)
        admin.role_assignments.create!(role_id: role.id)
      end
    end
  end

  desc '更新整理师信息'
  task :init_admin_200723 => :environment do
    realm = "Lijia"
    password = "lijia99"
    role = Role.find_by_name('senior_stockholder')
    {
      'zhongzhaoqiu' => '仲昭秋',

    }.each do |name, user_name|
      admin = Admin.find_by_name(name)
      if admin.blank?
        p_hash = Digest::MD5.hexdigest([name, realm, password].join(':'))
        admin = Admin.create!(name: name, password_hash: p_hash, active: true, user_name: user_name)
        admin.role_assignments.create!(role_id: role.id)
      end
    end
  end

  desc '更新客服信息'
  task :init_admin_200817 => :environment do
    realm = "Lijia"
    password = "lijia99"
    role = Role.find_by_name('admin_customer_service')
    {
      'wangxueru' => '王雪菇',
      'guozhifeng' => '郭志凤'

    }.each do |name, user_name|
      admin = Admin.find_by_name(name)
      if admin.blank?
        p_hash = Digest::MD5.hexdigest([name, realm, password].join(':'))
        admin = Admin.create!(name: name, password_hash: p_hash, active: true, user_name: user_name)
        admin.role_assignments.create!(role_id: role.id)
      end
    end

    realm = "Lijia"
    password = "lijia99"
    role = Role.find_by_name('admin_customer_service')
    {
      'fengjing' => '封静'

    }.each do |name, user_name|
      admin = Admin.find_by_name(name)
      if admin.blank?
        p_hash = Digest::MD5.hexdigest([name, realm, password].join(':'))
        admin = Admin.create!(name: name, password_hash: p_hash, active: true, user_name: user_name)
        admin.role_assignments.create!(role_id: role.id)
      end
    end

  end


  desc '更新客服信息20200821'
  task :init_admin_200821 => :environment do
    realm = "Lijia"
    password = "lijia99"
    role = Role.find_by_name('admin_customer_service')
    {
      'mahuijun' => '马慧君'

    }.each do |name, user_name|
      admin = Admin.find_by_name(name)
      if admin.blank?
        p_hash = Digest::MD5.hexdigest([name, realm, password].join(':'))
        admin = Admin.create!(name: name, password_hash: p_hash, active: true, user_name: user_name)
        admin.role_assignments.create!(role_id: role.id)
      end
    end
  end

  desc '更新客服信息20200825'
  task :init_admin_200825 => :environment do
    realm = "Lijia"
    password = "lijia99"
    role = Role.find_by_name('senior_stockholder')
    {
      'yinbo' => '银泊',
      'wangxiaoqin' => '王小琴'

    }.each do |name, user_name|
      admin = Admin.find_by_name(name)
      if admin.blank?
        p_hash = Digest::MD5.hexdigest([name, realm, password].join(':'))
        admin = Admin.create!(name: name, password_hash: p_hash, active: true, user_name: user_name)
        admin.role_assignments.create!(role_id: role.id)
      end
    end
  end

  desc '更新客服信息20200903'
  task :init_admin_200903 => :environment do
    realm = "Lijia"
    password = "lijia99"
    role = Role.find_by_name('admin_customer_service')
    {
      'heyanan' => '何娅楠'

    }.each do |name, user_name|
      admin = Admin.find_by_name(name)
      if admin.blank?
        p_hash = Digest::MD5.hexdigest([name, realm, password].join(':'))
        admin = Admin.create!(name: name, password_hash: p_hash, active: true, user_name: user_name)
        admin.role_assignments.create!(role_id: role.id)
      end
    end
  end

  desc '更新整理师信息'
  task :init_role_201111 => :environment do
    { 
      base_employee: '基础员工',
      senior_manage: '资深管理员'
    }.each do |role_name, description|
      Role.where(name: role_name, description: description).first_or_create
    end

    role = Role.find_by_name('senior_manage')
    {
      'tangling' => '唐玲',
      'bolei' => '薄蕾',
      'linxuefeng' => '林雪枫'
    }.each do |name, user_name|
      admin = Admin.find_by_name(name)
      if admin.present?
        admin.role_assignments.where(role_id: role.id).first_or_create
      end
    end
  end


  desc '更新股东信息20201122'
  task :init_admin_201122 => :environment do
    realm = "Lijia"
    password = "lijia99"
    role = Role.find_by_name('senior_stockholder')
    {
      'yuemingxia' => '岳明霞'

    }.each do |name, user_name|
      admin = Admin.find_by_name(name)
      if admin.blank?
        p_hash = Digest::MD5.hexdigest([name, realm, password].join(':'))
        admin = Admin.create!(name: name, password_hash: p_hash, active: true, user_name: user_name)
        admin.role_assignments.create!(role_id: role.id)
      end
    end
  end

  desc '更新整理师信息'
  task :init_role_201129 => :environment do
    { 
      junior_marketing: '营销专员',
    }.each do |role_name, description|
      Role.where(name: role_name, description: description).first_or_create
    end

    role = Role.find_by_name('junior_marketing')

    realm = "Lijia"
    password = "lijia99"

    {
      'wuwen' => '吴雯'

    }.each do |name, user_name|
      admin = Admin.find_by_name(name)
      if admin.blank?
        p_hash = Digest::MD5.hexdigest([name, realm, password].join(':'))
        admin = Admin.create!(name: name, password_hash: p_hash, active: true, user_name: user_name)
        admin.role_assignments.create!(role_id: role.id)
      end
    end
  end


  desc '更新整理师信息20201209'
  task :init_role_201209 => :environment do

    role = Role.find_by_name('senior_stockholder')
    realm = "Lijia"
    password = "lijia99"

    {
      'zhaoli' => '赵丽'

    }.each do |name, user_name|
      admin = Admin.find_by_name(name)
      if admin.blank?
        p_hash = Digest::MD5.hexdigest([name, realm, password].join(':'))
        admin = Admin.create!(name: name, password_hash: p_hash, active: true, user_name: user_name)
        admin.role_assignments.create!(role_id: role.id)
      end
    end
  end


  desc '更新整理师信息'
  task :init_role_201222 => :environment do
    { 
      junior_purchase: '采购',
    }.each do |role_name, description|
      Role.where(name: role_name, description: description).first_or_create
    end
  end

  desc '更新整理师信息'
  task :init_role_210101 => :environment do
    { 
      junior_customer_service: '基础客服',
    }.each do |role_name, description|
      Role.where(name: role_name, description: description).first_or_create
    end
  end

  desc '更新客服信息20210113'
  task :init_admin_200113 => :environment do
    realm = "Lijia"
    password = "lijia99"
    role = Role.find_by_name('admin_customer_service')
    {
      'wangyan' => '王燕'

    }.each do |name, user_name|
      admin = Admin.find_by_name(name)
      if admin.blank?
        p_hash = Digest::MD5.hexdigest([name, realm, password].join(':'))
        admin = Admin.create!(name: name, password_hash: p_hash, active: true, user_name: user_name)
        admin.role_assignments.create!(role_id: role.id)
      end
    end
  end


  desc '更新整理师信息20210110'
  task :init_role_200110 => :environment do

    role = Role.find_by_name('senior_stockholder')
    realm = "Lijia"
    password = "lijia99"

    {
      'zhoushaowei' => '周绍帷'

    }.each do |name, user_name|
      admin = Admin.find_by_name(name)
      if admin.blank?
        p_hash = Digest::MD5.hexdigest([name, realm, password].join(':'))
        admin = Admin.create!(name: name, password_hash: p_hash, active: true, user_name: user_name)
        admin.role_assignments.create!(role_id: role.id)
      end
    end
  end

  desc '更新整理师信息20210215'
  task :init_role_210215 => :environment do

    role = Role.find_by_name('admin_customer_service')
    realm = "Lijia"
    password = "lijia99"

    {
      'wangjichen' => '王继晨'

    }.each do |name, user_name|
      admin = Admin.find_by_name(name)
      if admin.blank?
        p_hash = Digest::MD5.hexdigest([name, realm, password].join(':'))
        admin = Admin.create!(name: name, password_hash: p_hash, active: true, user_name: user_name)
        admin.role_assignments.create!(role_id: role.id)
      end
    end
  end

  task :init_role_210302 => :environment do

    role = Role.find_by_name('admin_customer_service')
    realm = "Lijia"
    password = "lijia99"

    {
      'maiqiqi' => '麦淇淇'

    }.each do |name, user_name|
      admin = Admin.find_by_name(name)
      if admin.blank?
        p_hash = Digest::MD5.hexdigest([name, realm, password].join(':'))
        admin = Admin.create!(name: name, password_hash: p_hash, active: true, user_name: user_name)
        admin.role_assignments.create!(role_id: role.id)
      end
    end
  end


end