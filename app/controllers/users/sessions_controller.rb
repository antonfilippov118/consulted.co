class Users::SessionsController < Devise::SessionsController
  def create
    render json: { success: true }
  end
end
