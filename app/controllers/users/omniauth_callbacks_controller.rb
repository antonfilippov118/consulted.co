class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def linkedin
    if current_user
      connect_via_linkedin
    else
      sign_in_via_linkedin
    end
  end

  def failure
    redirect_to '/#!/signup'
  end

  private

  def connect_via_linkedin
    if current_user.connect_to_linkedin request.env['omniauth.auth']
      redirect_to '/#!/profile'
    else
      redirect_to '/#!/signup'
    end

  end

  def sign_in_via_linkedin
    email = request.env['omniauth.auth']['info']['email']
    begin
      @user = User.find_by email: email
    rescue => e
      @user = User.find_for_linkedin_oauth(request.env['omniauth.auth'])
    end

    if @user
      @user.connect_to_linkedin(request.env['omniauth.auth'])
      sign_in_and_redirect @user, event: :authentication
    else
      redirect_to '/#!/login'
    end
  end
end
