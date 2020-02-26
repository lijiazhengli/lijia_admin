namespace :student do 
  desc '更新学员信息'
  task :init_student => :environment do
    Student.where(phone_number: nil).each do |item|
      user = item.user
      item.update!(name: item.order.try(:customer_name), phone_number: user.phone_number)
    end
  end

  desc '更新学员用户折扣信息'
  task :init_student => :environment do
    user_ids = Student.where('created_at < ?', Time.new(2020,1,21,0,0,0)).pluck(:user_id)
    User.where(id: user_ids).where.not(phone_number: [nil, '']).update_all(zhekou: COURSE_STUDENT_ZHEKOU)

    Order.where(order_type: Order::COURSE_ORDER, status: 'completed').each do |order|
      student = Student.where(order_id: order.id).first
      user = order.user
      user.update!(zhekou: COURSE_STUDENT_ZHEKOU) if student.phone_number == user.phone_number and user.zhekou > COURSE_STUDENT_ZHEKOU
    end
  end

end