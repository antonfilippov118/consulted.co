Consulted::Application.routes.draw do

  controllers = {
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }
  devise_for :users, controllers: controllers, only: [:registrations, :confirmations]

  namespace :users do
    get :available, to: 'utilities#available'
  end
end
