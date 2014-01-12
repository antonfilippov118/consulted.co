class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def linkedin
    render json: { success: true }
  end
end
