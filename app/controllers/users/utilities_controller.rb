class Users::UtilitiesController < ApplicationController
  def available
    email = email_params.fetch :email
    exists = User.any_of({ email: email }, { contact_email: email}).exists?
    render json: !exists
  end

  private

  def email_params
    params.require(:user).permit :email
  end
end
