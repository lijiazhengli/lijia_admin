Rails.application.routes.draw do
  root 'welcome#index'
  get 'welcome/index'
  namespace :admin do
    #root "wx_menus#index"
    root "base#index"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
