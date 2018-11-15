Rails.application.routes.draw do
  root to: 'tasks#index'
  resources :tasks
  resources :users, only: %i[show new create destroy]
  resources :sessions, only: %i[new create destroy]
  resources :users, only: %i[new create destroy]
end
