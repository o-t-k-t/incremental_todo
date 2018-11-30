Rails.application.routes.draw do
  root to: 'tasks#index'
  resources :tasks
  resources :groups
  resource :user, only: %i[show new create destroy]
  resources :memberships, only: %i[index show new create destroy]
  resources :sessions, only: %i[new create destroy]

  namespace :admin do
    root to: 'users#index'
    resources :users
  end
end
