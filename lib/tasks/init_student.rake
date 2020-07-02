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

    phone_number = %w(
      13913279149 15103835906 13898840123 17743106338 15072490726 13708333844 17605302777 13898675526 18239305691
      17853009588 15234373494 13007045893 13599445389 13811306025 13084198315 13916968304 13755044485
      15120283788 13854255556 13392958149 18385293727 13954229283 15959448887 15239365888 13139972323 17719158339
      18564287117 13921291910 15080306661 13807804229 17799210909 18608004504 15002310155 15527349217 13809433484
      18153117721 15538080939 13369182555 13520852735 13345196251 15878815252 13792395461
    )
    User.where(phone_number: phone_number).update_all!(zhekou: 0.6)
  end

  task :init_canceled_order_student => :environment do
    o_ids = Order.where(order_type: 'Course', status: 'canceled').pluck(:id)
    Student.where(order_id: o_ids).destroy_all
  end
end