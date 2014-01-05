# encoding: utf-8

# controller for the User class, mostly for the public methods
# not requiring authorization
class UsersController < ApplicationController
  respond_to :json

  def create
    @user = user_class.new user_params
    result = RegistersUser.for_new @user

    if result.failure?
      head :bad_request
    else
      head :created
    end
  end

  def show
    head :forbidden
  end

  def auth
    result = AuthenticatesUser.check auth_params

    if result.failure?
      head :unauthorized
    else
      head :ok
      set_auth_cookie
    end
  end

  private

  def user_class
    User
  end

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

  def auth_params
    params.permit(:email, :password)
  end

  def set_auth_cookie
    cookies[:__consulted] = {
      value: 'foo',
      expires: 1.hour.from_now
    }
  end
end
