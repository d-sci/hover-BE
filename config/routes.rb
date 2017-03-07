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
  
end
