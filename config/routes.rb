Rails.application.routes.draw do
  resources :trips
  resources :pools
  resources :users do
    member do
      get :active_trips
    end
  end
  post 'authenticate', to: 'authentication#authenticate'
  
end
