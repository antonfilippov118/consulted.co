Consulted::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  admin_controllers = {
    sessions: 'admins/sessions'
  }

  investor_controllers = {
    sessions: 'investors/sessions'
  }

  controllers = {
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks',
    passwords: 'devise/passwords'
  }

  devise_for :admins, controllers: admin_controllers, only: admin_controllers.keys
  devise_for :investors, controllers: investor_controllers, only: investor_controllers.keys
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

    resources :offers, only: [:create], controller: 'users/offers' do
      get '/review', action: :review
    end

    scope :'my-calls', controller: 'users/history' do
      get '/', action: :show
      get :requested, path: 'requested', constraints: { format: 'json' }
      get :offered, path: 'offered', constraints: { format: 'json' }
    end

    resource :settings, only: [], controller: 'users/settings' do
      get '/',  action: :profile

      patch :profile, action: :user_update
      patch :linkedin, action: :linkedin
      patch :connect_linkedin, action: :linkedin_connect
      put :timezone, action: :timezone_update
    end

    resource :availabilities, except: [:edit, :new], controller: 'users/availabilities'
    resources :availabilities, only: [:destroy], controller: 'users/availabilities'
    resources :favorites, except: [:edit, :new], controller: 'users/favorites'

    resources :requests, controller: 'users/requests', except: [:new] do
      member do
        patch :cancel
        patch :accept
      end
      collection do
        get :review, path: '/:slug/:offer_id'
      end
    end

    resource :requests, only: [] do
      get :success
    end

    resources :calls, only: [:index], controller: 'users/calls' do
      put :confirm
      delete :cancel
    end

    get :contact_email, controller: 'users/dashboard', action: :contact
    get :synchronisation, controller: 'users/dashboard', action: :synchronisation
    patch :synch_linkedin, controller: 'users/dashboard', action: :linkedin
    patch :contact_email, controller: 'users/dashboard', action: :update_contact
    patch :timezone, controller: 'users/dashboard', action: :timezone
  end

  resources :groups, only: [:show, :index]
  resource :group, only: [] do
    post :search
  end

  resource :offers, only: [:show] do
    get '/:id/show', to: 'offers#show', constraints: { format: 'json' }
    get '/:expert', to: 'offers#index', constraints: { format: 'json' }
  end

  resource :availabilities, only: [] do
    get '/:expert', to: 'availabilities#index', constraints: { format: 'json' }
  end

  resource :times, only: [] do
    get '/:expert/:group', to: 'times#index', constraints: { format: 'json' }
  end

  namespace :users do
    get :available, to: 'utilities#available'
    get :regions, to: 'utilities#region'
  end

  get :find_an_expert, controller: 'search', action: :show

  post :search, to: 'search#search'

  resource :contact, only: [:new, :create] do
    get :success
  end

  namespace :call do
    post '/', action: :welcome
    post :enter, action: :enter_pin
    post :find, action: :lookup
  end

  # static pages
  [
    :confidentiality,
    :make_the_most,
    :about_us,
    :privacy,
    :case_studies,
    :terms,
    :join_as_expert,
    :how_it_works
  ].each do |page|
    get page, controller: :static
  end

  get '/timezone', controller: 'users/utilities', action: 'timezone', constraints: { format: 'json' }

  get '/fonts/flaticon', controller: 'fonts/flaticon', action: :show

  %w(404 422 500).each do |code|
    get "/#{code}", to: 'errors#show', code: code
  end

  get '/:slug', to: 'expert#page'

  root to: 'home#index'
end
