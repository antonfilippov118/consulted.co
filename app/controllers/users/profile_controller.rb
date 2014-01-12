class Users::ProfileController < Devise::SessionsController
  before_filter :authenticate!
  skip_before_filter :authenticate_scope!, only: [:profile]

  def show
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
