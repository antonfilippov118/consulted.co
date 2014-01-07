class Users::RegistrationsController < Devise::RegistrationsController
  def create
    head :method_not_allowed
  end
end
