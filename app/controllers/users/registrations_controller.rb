class Users::RegistrationsController < Devise::RegistrationsController
  def create
    head :bad_request
  end
end
