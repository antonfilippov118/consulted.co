Consulted::Application.routes.draw do
  resource :user, only: [:show, :create] do
  end
end
