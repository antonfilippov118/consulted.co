Consulted::Application.routes.draw do

  controllers = {
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  devise_for :users, controllers: controllers, only: controllers.keys

  namespace :users do
    get :available, to: 'utilities#available'
    get :profile, to: 'profile#profile'
  end
end
