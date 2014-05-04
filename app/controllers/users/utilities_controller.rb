class Users::UtilitiesController < ApplicationController
  def available
    exists = User.where(email: email_params[:email]).exists?
    if exists
      render json: false
    else
      render json: true
    end
  end

  private

  def email_params
    params.require(:user).permit :email
  end
end
