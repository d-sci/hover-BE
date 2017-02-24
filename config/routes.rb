Rails.application.routes.draw do
  resources :trips
  resources :users
  post 'authenticate', to: 'authentication#authenticate'
  
end
