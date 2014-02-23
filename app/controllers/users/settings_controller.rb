class Users::SettingsController < Users::BaseController
  def profile
  end

  def billing
  end

  def accounts
  end

  def notifications
  end

  def user_update
    result = UpdatesUserProfile.with_params current_user, user_profile_params
    if result.failure?
      @errors = result[:errors]
      render :profile, danger: result.message
    else
      redirect_to settings_path, notice: 'Profile updated!'
    end
  end

  def user_profile_params
    params.require(:user).permit :name, :slug, :email, :summary, :timezone, :profile_image
  end
end
