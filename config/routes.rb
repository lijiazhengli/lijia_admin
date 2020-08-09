Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  root 'home#index'
  #root "admin/base#admin_login"

  get '/information', to: "home#info"

  post '/wx_payment', to: 'weixin#wx_verify'

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

    resources :cases do
      collection do
        post :file_upload
        put :file_upload
        patch :file_upload
        put :up_serial
        put :down_serial
      end
      member do
        put :disable
        put :enable
      end
    end

    resources :courses do
      resources :course_extends
      collection do
        post :file_upload
        put :file_upload
        patch :file_upload
        put :up_serial
        put :down_serial
      end
      member do
        put :disable
        put :enable
        get :order
      end
      resources :course_teachers
      resources :students
    end

    resources :franchises do
      collection do
        get  :kefu_index
        post :file_upload
        put :file_upload
        patch :file_upload
        put :up_serial
        put :down_serial
      end
      member do
        put :disable
        put :enable
        get :order
        put :completed
        put :canceled
        put :update_status
      end
      resources :franchise_images do
        collection do
          post :file_upload
          put :file_upload
          patch :file_upload
          put :up_serial
          put :down_serial
        end
        member do
          put :disable
          put :enable
        end
      end

    end

    resources :goods do
      collection do
        get :order
        post :file_upload
        put :file_upload
        patch :file_upload
        put :up_serial
        put :down_serial
      end
      member do
        put :disable
        put :enable
      end
    end

    resources :introduces do
      collection do
        post :file_upload
        put :file_upload
        patch :file_upload
      end
    end

    resources :orders do
      collection do
        get :accounting
      end
      member do
        get :base_show
        put :completed
        put :canceled
        put :update_status
      end
      resources :delivery_orders
      resources :order_arranger_assignments
      resources :order_payment_records
      resources :purchased_items
    end

    resources :order_payment_records, only: [:index, :show] do
      collection do
        put :cancel
        post :confirm_refund
        post :received
        post :refund
        get  :reimbursement
        get  :refund_index
      end
    end

    resources :pages

    resources :products do
      resources :product_images do
        collection do
          post :file_upload
          put :file_upload
          patch :file_upload
          put :up_serial
          put :down_serial
        end
        member do
          put :disable
          put :enable
        end
      end
    end

    resources :services do
      collection do
        post :file_upload
        put :file_upload
        patch :file_upload
        put :up_serial
        put :down_serial
      end
      member do
        put :disable
        put :enable
      end
    end

    resources :students
    resources :teachers do
      collection do
        post :file_upload
        put :file_upload
        patch :file_upload
      end
    end

    resources :tongjis, only: [:index] do
      collection do
        get :achievement
        get :city
        get :course
      end
    end
    resources :users
  end

  resources :applets, only: [:index, :show] do
    collection do
      get  :cart
      get  :cart_base_show
      get  :cart_show
      post :check_order_status
      post :cancel_franchise
      post :cancel_order
      get  :course_index
      post :create_apply_order
      post :create_order
      post :create_course_order
      post :create_service_order
      get  :crm_info
      post :delete_user_address
      get  :franchise_index
      get  :franchise_show
      get  :good_index
      get  :home_show
      get  :login
      get  :load_address_list
      get  :load_address_info
      get  :load_customer_info
      get  :load_product_infos
      get  :orders
      get  :order_show
      get  :product_show
      get  :set_phone
      get  :service_index
      post :save_address
      post :save_user_info
      get  :user_info
      get  :user_franchises
    end
  end

  resources :courses, only: [:index, :show] do
  end

  resources :goods, only: [:index, :show] do
  end

  resources :pages, only: [:show] do
  end

  resources :services, only: [:index, :show] do
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
