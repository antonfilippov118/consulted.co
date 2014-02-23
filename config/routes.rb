Consulted::Application.routes.draw do

  controllers = {
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  devise_for :users, controllers: controllers, only: controllers.keys

  devise_scope :user do

    get :overview, controller: 'users/dashboard', action: :show, path: 'overview'
    get :search, controller: 'users/search', action: :show, path: 'search'
    get :offer, controller: 'users/offer', action: :show, path: 'offer'
    get :settings, controller: 'users/settings', action: :show, path: 'settings'
    get :history, controller: 'users/dashboard', action: :history, path: 'history'

  end

  resource :offers, only: [:show]

  namespace :users do
    get :available, to: 'utilities#available'
  end

  resource :groups, only: [:show]

  root to: 'home#index'
end
