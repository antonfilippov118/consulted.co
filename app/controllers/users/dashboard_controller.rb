class Users::DashboardController < Users::BaseController
  include CallsHelper
  before_filter :needs_contact_email?, only: :contact

  def show
    title! 'Overview'
    upcoming_calls
  end

  def history
    title! 'Your calls'
  end

  def contact
  end

  def timezone
    result = UpdatesUserProfile.with_params @user, timezone_params
    if result.failure?
      render json: { error: true }
    end
  end

  def update_contact
    if @user.update_attributes contact_params
      redirect_to overview_path
    else
      render :contact, alert: 'Could not save your contact email, please try again.'
    end
  end

  private

  def contact_params
    params.require(:user).permit :contact_email, :newsletter
  end

  def timezone_params
    params.require(:user).permit :timezone
  end

  def needs_contact_email?
    new_user            = @user.sign_in_count == 1
    needs_contact_email = @user.contact_email.nil?
    social              = !@user.providers.nil?

    unless new_user && needs_contact_email && social
      redirect_to overview_path
    end
  end
end
