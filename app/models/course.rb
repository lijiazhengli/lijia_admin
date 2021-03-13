class Course < Product
  include LijiaLocal
  has_many  :students
  accepts_nested_attributes_for :students, allow_destroy: true

  has_many  :course_city_infos

  has_one  :course_extend
  accepts_nested_attributes_for :course_extend, allow_destroy: true

  has_many  :course_teachers
  has_many  :teachers, through: :course_teachers

  scope :applet_home, -> {where(active: true).order(:position)}

  # 是否使用配置的活动金额
  def event_price_usable?
    event_price.present? && event_price > 0
  end

  def to_applet_list
    attrs = {
      id: self.id,
      title: self.title,
      desc: self.description,
      price: self.price,
      city_name: self.city_name,
      start_date: self.start_date,
      end_date: self.end_date,
      img_url: change_to_qiniu_https_url(self.front_image)
    }
    info_extend = self.self_extend
    attrs[:show_city_list] = true  if info_extend.present? and info_extend.show_city_list
    attrs
  end

  def get_desc_title
    arr = []
    arr << get_string_date_info(self.start_date) if self.start_date.present?
    arr << get_string_date_info(self.end_date) if self.end_date.present?
    arr.join('-')
  end

  def get_string_date_info(str)
    str[-5..-1].split('-').join('月') + '日'
  end

  def to_recommend_list
    {
      id: self.id,
      title: self.get_desc_title
    }
  end

  def self_extend
    CourseExtend.find_or_create_by(course_id: self.id)
  end

  def course_show_time
    "#{self.show_start_date}-#{self.show_end_date}"
  end

  def course_short_time
    "#{self.show_start_date[5..-1]}-#{self.show_end_date[5..-1]}"
  end

  def city_infos_list
    date_list = {}
    address_list = {}
    self.course_city_infos.active.each do |info|
      if info.date_info.present?
        date_list[info.city_name] ||= []
        date_list[info.city_name] << info.date_info
        address_list[info.city_name] ||= info.address if info.address.present?
      end
    end
    [date_list, address_list]
  end

  def v2_city_infos_list
    self.course_city_infos.active.order('date_info asc')
  end

  class << self
    def get_recommend_infos(course_id)
      infos = {}
      Course.active.where.not(id: course_id).order(:city_name, :start_date).each do |course|
        infos[course.city_name] ||= []
        infos[course.city_name] << course.to_recommend_list
      end
      infos
    end
  end
end