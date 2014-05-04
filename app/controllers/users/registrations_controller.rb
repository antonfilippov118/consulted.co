class Users::RegistrationsController < Devise::RegistrationsController

  private

  def sign_up_params
    allow = [:email, :name, :newsletter, :password, :password_confirmation]
    params.require(resource_name).permit(allow)
  end
end
