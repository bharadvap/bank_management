Rails.application.routes.draw do
  devise_for :users
  resources :transactions
  get 'profile', to: 'home#profile', as: "profile"
  root 'home#index'
end
