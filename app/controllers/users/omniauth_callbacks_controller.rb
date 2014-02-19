class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def linkedin
    if current_user
      connect_via_linkedin
    else
      sign_in_via_linkedin
    end
  end

  def failure
    redirect_to new_user_registration_path, warning: 'Could not connect to Linkedin!'
  end

  private

  def connect_via_linkedin
    if current_user.connect_to_linkedin request.env['omniauth.auth']
      redirect_to user_profile_path
    else
      redirect_to new_user_registration_path
    end

  end

  def sign_in_via_linkedin
    @user = find_user

    if @user
      @user.connect_to_linkedin(request.env['omniauth.auth'])
      sign_in_and_redirect @user, event: :authentication
    else
      redirect_to '/#!/login'
    end
  end

  def find_user
    email = request.env['omniauth.auth']['info']['email']

    begin
      @user = User.find_by email: email
    rescue
      @user = User.find_for_linkedin_oauth(request.env['omniauth.auth'])
    end
    @user
  end
end
