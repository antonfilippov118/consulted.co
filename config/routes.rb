Consulted::Application.routes.draw do

  controllers = {
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  devise_for :users, controllers: controllers, only: controllers.keys

  devise_scope :user do
    get :profile, controller: 'users/profile', action: 'show'
    post :synch, controller: 'users/profile', action: 'synch_linkedin'

    patch :profile, controller: 'users/profile', action: 'update'

    get :offers, controller: 'users/offers', action: 'show', path: 'profile/offers'
    put :offers, controller: 'users/offers', action: 'update', path: 'profile/offers'

    put    :availabilities, controller: 'users/availabilities', action: 'update', path: 'profile/availabilities'
    get    :availabilities, controller: 'users/availabilities', action: 'show', path: 'profile/availabilities'
    delete :availabilities, controller: 'users/availabilities', action: 'destroy', path: 'profile/availabilities/:id'

    post :search, controller: 'users/search_offers'
  end

  namespace :users do
    get :available, to: 'utilities#available'
  end

  resource :groups, only: [:show]

  root to: 'home#index'
end
