Rails.application.routes.draw do
  root to: 'groups#index'
  resources :groups
  resources :users, only: [:new, :create]
end
