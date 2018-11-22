Rails.application.routes.draw do
  root to: 'tasks#index'
  resources :tasks
  resource :user, only: %i[show new create destroy]
  resources :sessions, only: %i[new create destroy]

  namespace :admin do
    root to: 'users#index'
    resources :users
  end
end
