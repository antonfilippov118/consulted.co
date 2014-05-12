class Users::SettingsController < Users::BaseController
  before_filter -> { @errors = [] }
  skip_before_filter :verify_authenticity_token, only: :timezone_update
  def profile
  end

  def billing
  end

  def accounts
  end

  def notifications
  end

  def user_update
    result = UpdatesUserProfile.with_params @user, user_profile_params
    respond_to do |format|
      format.html { handle_html result }
      format.js { handle_js result }
    end
  end

  def timezone_update
    respond_to do |format|
      format.json do
        if @user.update_attributes timezone_params
          render json: { success: true }
        else
          render json: { error: @user.errors }, status: :bad_request
        end
      end
    end
  end

  def linkedin
    respond_to do |format|
      format.js do
        @result = SynchronizeLinkedinProfile.for @user
      end
    end
  end

  def linkedin_connect
    session[:omniauth_return] = settings_path
    redirect_to user_omniauth_authorize_path provider: 'linkedin'
  end

  private

  def user_profile_params
    params.require(:user).permit :name, :slug, :contact_email, :summary, :timezone, :profile_image, :country, :break, :meeting_notification, :notification_time, :shares_career, :shares_education, :shares_summary, :max_meetings_per_day, :start_delay, :twitter_handle, languages: []
  end

  def timezone_params
    params.require(:user).permit :timezone
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

  def handle_js(result)
    @result = result
  end
end
