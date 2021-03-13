class AddIsCourseDiscountToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_course_discount, :boolean, default: false, comment: '是否享受课程优惠'
  end
end
