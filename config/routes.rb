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
  post 'authenticate', to: 'authentication#authenticate'
  post 'activate_account', to: 'authentication#activate_account'
  post 'reset_password', to: 'authentication#reset_password'
  post 'register', to: 'authentication#register'
  post 'forgot_password', to: 'authentication#forgot_password'
  
end
