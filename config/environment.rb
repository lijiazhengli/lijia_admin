# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

QUANGUO_ALL_PROVINCE_NAMES = %w(北京 上海 天津 四川 广东 河北 江苏 安徽 浙江 重庆 贵州 云南 西藏 河南 湖北 湖南 广西 陕西 甘肃 青海 宁夏 新疆 山西 内蒙古 福建 江西 山东 辽宁 吉林 黑龙江 海南)

QUANGUO_PRODUCT_INDELIVERY_PROVINCE_NAME = [] # %w(新疆 青海 西藏 宁夏 内蒙古 甘肃)
QUANGUO_PRODUCT_INDELIVERY_CITY_NAME = []
QUANGUO_PRODUCT_INDELIVERY_AREA_NAME = []

QUANGUO_PRODUCT_DELIVERY_FEE_INFOS = {
  "新疆" => {base_delivery_fee: 10, base_product_cost: 50, unit_product_cost: 25, unit_delivery_fee: 5}
}

COURSE_STUDENT_ZHEKOU = 0.8