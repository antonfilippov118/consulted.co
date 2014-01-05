Consulted::Application.routes.draw do
  resource :user, only: [:show, :create] do
    post :auth
  end
end
