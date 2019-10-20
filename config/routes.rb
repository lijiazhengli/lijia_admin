Rails.application.routes.draw do
  root 'welcome#index'
  get 'welcome/index'
  namespace :admin do
    #root "wx_menus#index"
    root "base#index"
    get 'home' => 'base#home'
    get 'index' => 'admin#index' 
    post 'do_login' => 'admin#do_login'
    delete 'do_logout' => 'admin#do_logout' 

    resources :arrangers

    resources :courses do
      collection do
        post :file_upload
        put :file_upload
        patch :file_upload
      end
    end

    resources :goods do
      collection do
        post :file_upload
        put :file_upload
        patch :file_upload
      end
    end

    resources :services do
      collection do
        post :file_upload
        put :file_upload
        patch :file_upload
      end
    end

    

    resources :orders do
      resources :order_arranger_assignments
      resources :order_payment_records
      resources :purchased_items
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
