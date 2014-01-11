class Users::ProfileController < Devise::SessionsController
  before_filter :authenticate!

  def profile
    render json: { email: current_user.email, name: current_user.name, confirmed: current_user.confirmed? }
  end

  private

  def authenticate!
    fail! unless warden.authenticate? scope: resource_name
  end

  def fail!
    render json: { error: 'Access denied!' }, status: 401
  end

end
