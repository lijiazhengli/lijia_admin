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

  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
