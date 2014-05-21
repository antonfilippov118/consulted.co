class Users::DashboardController < Users::BaseController
  include CallsHelper
  before_filter :needs_linkedin_synch?, only: :show
  before_filter :needs_contact_email?, only: :show
  before_filter :ask_contact_email?, only: :show

  def show
    title! 'Overview'
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
    if @user.update_attributes contact_params.merge asked_contact_email: true
      redirect_to overview_path
    else
      render :contact, alert: 'Could not save your contact email, please try again.'
    end
  end

  def synchronisation
  end

  def linkedin
    result = SynchronizeLinkedinProfile.for @user
    if result.failure?
      render json: { error: e.message }
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
    social              = @user.signed_up_via == 'linkedin'
    asked               = @user.asked_contact_email?

    if new_user && needs_contact_email && social && !asked
      redirect_to contact_email_path
    end
  end

  def needs_linkedin_synch?
    if @user.linkedin? && !@user.linkedin_synchronized?
      redirect_to synchronisation_path
    end
  end

  def ask_contact_email?
    if @user.signed_up_via == 'linkedin' && @user.asked_contact_email? == false
      redirect_to contact_email_path
    end
  end
end
