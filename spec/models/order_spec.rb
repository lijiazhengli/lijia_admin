RSpec.describe Order, type: :model do
  describe '.create_or_update_order' do
    context '不能创建学员' do
      before do
        @options = {
          order_attr: {},
          params: {},
          purchased_items: [],
          methods: %w(check_user create_order create_course_student save_with_new_external_id),
          redis_expire_name: "cart-#{15900000000}"
        }
      end
      it do
        result = Order.create_or_update_order(@options)
        puts result
        expect(result[0]).to be_present
        expect(result[1]).to eq false
        expect(result[2][:raise_erro]).to eq '不能创建学员'
      end
    end
    context 'success' do
      before do
        @user = create(:user)
        @options = {
          order_attr: { order_type: 'Product', user_id: @user.id, customer_name: '', recipient_name: '', recipient_phone_number: '15900000000', purchased_items_attributes: {}},
          params: {},
          purchased_items: [],
          methods: %w(check_user create_order create_course_student save_with_new_external_id),
          redis_expire_name: "cart-#{15900000000}"
        }
      end
      it do
        result = Order.create_or_update_order(@options)
        puts result
        expect(result[0]).to be_present
        expect(result[1]).to eq true
        expect(result[2].keys.count).to eq 0
      end
    end
  end
end