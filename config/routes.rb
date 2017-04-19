Rails.application.routes.draw do
  
  # Default resources. NB Don't actually need many of these, especially pools.
  resources :requests
  resources :pools
  resources :trips  do
    member do
      get :confirm
    end
  end
  resources :users
  
  # Authentication
  post 'authenticate', to: 'authentication#authenticate'
  post 'activate_account', to: 'authentication#activate_account'
  post 'reset_password', to: 'authentication#reset_password'
  post 'register', to: 'authentication#register'
  post 'forgot_password', to: 'authentication#forgot_password'
  
  # Matching
  post 'find_match', to: 'matching#find_match'
  
  # Dashboard
  get 'active_carpools', to: 'dashboard#active_carpools'
  get 'pending_carpools', to: 'dashboard#pending_carpools'
  get 'personal_trips', to: 'dashboard#personal_trips'
  get 'in_requests', to: 'dashboard#in_requests'
  get 'out_requests', to: 'dashboard#out_requests'
  get 'full_dashboard', to: 'dashboard#full_dashboard'
  
end
