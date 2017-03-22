Rails.application.routes.draw do
  
  # Default resources. NB Don't actually need many of these, especially pools.
  resources :requests
  resources :pools
  resources :trips  do
    member do
      get :active_users
    end
  end
  resources :users do
    member do
      get :active_trips, :active_copoolers
    end
  end
  
  # Authentication
  post 'authenticate', to: 'authentication#authenticate'
  post 'activate_account', to: 'authentication#activate_account'
  post 'reset_password', to: 'authentication#reset_password'
  post 'register', to: 'authentication#register'
  post 'forgot_password', to: 'authentication#forgot_password'
  
  # Matching
  post 'find_match', to: 'matching#find_match'
  
end
