class Users::SettingsController < Users::BaseController
  before_filter -> { @errors = [] }
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
    respond_to do |format|
      format.html { handle_html result }
      format.js { handle_js result }
    end
  end

  private

  def user_profile_params
    params.require(:user).permit :name, :slug, :email, :summary, :timezone, :profile_image, :country, :break, :meeting_notification, :notification_time, languages: []
  end

  def handle_html(result)
    if result.failure?
      flash.now[:danger] = result.message
      @errors = result[:errors]
      render :profile
    else
      redirect_to settings_path, notice: 'Profile updated!'
    end
  end

  def handle_js
    if result.failure?
      render json: { errors: result[:errors], message: result.message }
    else
      render json: { success: true }
    end
  end
end
