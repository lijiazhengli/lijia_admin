namespace :user do
  desc '初始化用户，course_extends.has_student_zhekou 是true,并且该用户有成功的订单purchased_items.product_id 状态已完成，给该用户打标签'
  task :current_user_role => :environment do
    User.all.find_each do |user|
      order_ids = user.orders.where(status: ['paided', 'completed']).pluck(:id)
      next if order_ids.blank?
      course_ids = PurchasedItem.includes(:product).where(purchased_items: {order_id: order_ids}, products: {type: 'Course'}).pluck(:product_id)
      is_course_discount = Course.includes(:course_extend).where(id: course_ids, course_extends: {has_student_zhekou: true}).count > 0
      if is_course_discount
        user.update(is_course_discount: true)
      end
    end
  end
end