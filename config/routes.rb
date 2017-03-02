Rails.application.routes.draw do
  resources :trips
  resources :users do
    member do
      get :trips
    end
  end
  post 'authenticate', to: 'authentication#authenticate'
  
end
