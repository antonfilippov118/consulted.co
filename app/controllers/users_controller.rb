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

  private

  def user_class
    User
  end

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
