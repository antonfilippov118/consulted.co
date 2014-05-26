class Users::UtilitiesController < ApplicationController
  def available
    email = email_params.fetch :email
    exists = User.with_email(email).exists?
    render json: !exists
  end

  def timezone

  end

  private

  def email_params
    params.require(:user).permit :email
  end
end
