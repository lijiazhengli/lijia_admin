FactoryBot.define do
  factory :order do
    user
    admin_id { 1 }
    city_name { '临沂市' }
    start_date { '' }
    end_date { '' }
    status { 'unpaid' }

    factory :order_service do
      order_type { 'Service' }
    end

    factory :order_course do
      order_type { 'Course' }
    end

    factory :order_product do
      order_type { 'Product' }
    end
  end
end
