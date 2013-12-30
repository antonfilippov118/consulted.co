class UsersController < ApplicationController
  def create
    @user = user_class.new user_params
    result = RegistersUser.for_new @user

    if result.failure?
      head :bad_request
    else
      head :created
    end
  end

private
  def user_class
    User
  end

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end