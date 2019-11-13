Rails.application.routes.draw do
  #root 'welcome#index'
  root "admin/base#admin_login"
  get 'welcome/index'
  namespace :admin do
    #root "wx_menus#index"
    root "base#admin_login"
    get 'home' => 'base#home'
    get 'index' => 'admin#index' 
    post 'do_login' => 'admin#do_login'
    delete 'do_logout' => 'admin#do_logout' 

    resources :admin

    resources :ad_images do
      collection do
        post :file_upload
        put :file_upload
        patch :file_upload
      end
    end

    resources :arrangers do
      member do
        get :service_orders
      end
    end

    resources :courses do
      collection do
        post :file_upload
        put :file_upload
        patch :file_upload
      end
      resources :course_teachers
      resources :students
    end

    resources :goods do
      collection do
        post :file_upload
        put :file_upload
        patch :file_upload
      end
    end

    resources :orders do
      member do
        get :base_show
      end
      resources :order_arranger_assignments
      resources :order_payment_records
      resources :purchased_items
    end

    resources :services do
      collection do
        post :file_upload
        put :file_upload
        patch :file_upload
      end
    end

    resources :students
    resources :teachers
    resources :users
  end

  resources :applets, only: [:index, :show] do
    collection do
      get  :product_show
      get  :cart
      post :check_order_status
      post :cancel_order
      post :delete_user_address
      get  :login
      get  :load_address_list
      get  :load_address_info
      get  :orders
      get  :order_show
      get  :set_phone
      post :save_address
      post :create_order
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
