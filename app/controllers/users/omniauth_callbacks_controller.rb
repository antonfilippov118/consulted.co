class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def linkedin
    if current_user
      connect_via_linkedin
    else
      sign_in_via_linkedin
    end
  end

  private

  def connect_via_linkedin
    if current_user.connect_to_linkedin request.env['omniauth.auth']
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  def sign_in_via_linkedin
    @user = User.find_for_linkedin_oauth(request.env['omniauth.auth'])

    if @user
      @user.connect_to_linkedin(request.env['omniauth.auth'])
      sign_in @user, event: :authentication
      redirect_to '/#!/profile'
    else
      render json: { success: false }
    end
  end
end
