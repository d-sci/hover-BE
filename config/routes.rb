Rails.application.routes.draw do
  resources :pools
  resources :trips  do
    member do
      get :active_users
    end
  end
  resources :users do
    member do
      get :active_trips
    end
  end
  post 'login', to: 'authentication#login'
  post 'account_activation', to: 'authentication#account_activation'
  post 'password_reset', to: 'authentication#password_reset'
  
end
