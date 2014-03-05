Consulted::Application.routes.draw do

  controllers = {
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  get :search, controller: 'search', action: :show, path: 'search'

  devise_for :users, controllers: controllers, only: controllers.keys

  devise_scope :user do
    get :overview, controller: 'users/dashboard', action: :show, path: 'overview'
    get :offer, controller: 'users/offer', action: :show, path: 'offer'
    get :history, controller: 'users/dashboard', action: :history, path: 'history'

    resource :settings, only: [] do
      get '/', controller: 'users/settings', action: :profile
      get '/billing', controller: 'users/settings', action: :billing
      get '/accounts', controller: 'users/settings', action: :accounts
      get '/notifications', controller: 'users/settings', action: :notifications

      patch :profile, controller: 'users/settings', action: :user_update
      patch :notifications, controller: 'users/settings', action: :user_notifications_update
    end
  end

  resources :groups, only: [:show, :index]
  resource :offers, only: [:show]

  namespace :users do
    get :available, to: 'utilities#available'
  end

  root to: 'home#index'
end
