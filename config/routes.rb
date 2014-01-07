Consulted::Application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }, only: [:registrations]
end
