RSpec.describe Admin::OrdersController, type: :controller do
  describe '#index' do
    context 'success' do
      before do
        sign_in_admin!
        create(:order)
        @params = {}
      end
      it do
        get :index, params: @params
        expect(response.status).to eq 200
        expect(response).to render_template("index")
      end
    end
    context 'export' do
      before do
        sign_in_admin!
        @params = {commit: '导出数据'}
      end
      it do
        get :index, params: @params
        puts response
        expect(response).to render_template nil
      end
    end
  end
end