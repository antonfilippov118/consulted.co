module Authenticable
  extend ActiveSupport::Concern

  private

  def authenticate!
    fail! unless warden.authenticate? scope: resource_name
  end

  def fail!
    render json: { error: 'Access denied!' }, status: 401
  end
end
