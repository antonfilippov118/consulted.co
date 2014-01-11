class Users::ProfileController < Devise::SessionsController
  before_filter :authenticate!

  def profile
    render json: { email: 'florian@consulted.co', name: 'Florian' }
  end

  private

  def authenticate!
    fail! unless warden.authenticate? scope: resource_name
  end

  def fail!
    render json: { error: 'Access denied!' }, status: 401
  end

end
