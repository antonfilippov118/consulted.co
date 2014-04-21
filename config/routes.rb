Consulted::Application.routes.draw do

  admin_controllers = {
    sessions: 'admins/sessions'
  }

  controllers = {
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks',
    passwords: 'devise/passwords'
  }

  devise_for :admins, controllers: admin_controllers, only: admin_controllers.keys
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  get :search, controller: 'search', action: :show, path: 'search'

  devise_for :users, controllers: controllers, only: controllers.keys

  devise_scope :user do
    get :overview, controller: 'users/dashboard', action: :show, path: 'overview'
    patch '/users/confirmation' => 'users/confirmations#update', via: :patch, as: :update_user_confirmation

    resource :offers, only: [:show, :update], controller: 'users/offers' do
      get :list
      put :activate
    end

    get :history, controller: 'users/dashboard', action: :history, path: 'history'

    resource :settings, only: [] do
      get '/', controller: 'users/settings', action: :profile
      get '/billing', controller: 'users/settings', action: :billing
      get '/accounts', controller: 'users/settings', action: :accounts
      get '/notifications', controller: 'users/settings', action: :notifications

      patch :profile, controller: 'users/settings', action: :user_update
      put :timezone, controller: 'users/settings', action: :timezone_update
    end

    resource :availabilities, except: [:edit, :new], constraints: { format: /(js|json)/ }, controller: 'users/availabilities'
    resources :favorites, except: [:edit, :new], controller: 'users/favorites'

    resources :requests, controller: 'users/requests', except: [:new] do
      get :success
      member do
        patch :cancel
        patch :decline
        patch :accept
      end
      collection do
        get :review, path: '/:slug/:offer_id'
      end
    end

    get :contact_email, controller: 'users/dashboard', action: :contact
    patch :contact_email, controller: 'users/dashboard', action: :update_contact
    patch :timezone, controller: 'users/dashboard', action: :timezone
  end

  resources :groups, only: [:show, :index]
  resource :group, only: [] do
    post :search
  end

  resource :offers, only: [:show]

  namespace :users do
    get :available, to: 'utilities#available'
  end

  get :find_an_expert, controller: 'search', action: :show

  post :search, to: 'search#search'

  namespace :call do
    post '/', action: :handle
    post :find, action: :lookup
  end

  # static pages
  [
    :confidentiality,
    :make_the_most,
    :about_us,
    :privacy,
    :success_stories,
    :terms
  ].each do |page|
    get page, controller: :static
  end

  get '/:slug', to: 'expert#page'

  root to: 'home#index'
end
