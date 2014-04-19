class Users::DashboardController < Users::BaseController
  before_filter :needs_contact_email?, only: :contact
  def show
    @requests     = @user.requests.active
    @outstanding  = Request.active.by @user
    @calls        = @user.active_calls
    @upcoming     = @user.future_calls
  end

  def history
  end

  def contact
  end

  def update_contact
    if @user.update_attributes contact_params
      redirect_to overview_path
    else
      render :contact, alert: 'Could not save yur contact email, please try again.'
    end
  end

  private

  def contact_params
    params.permit :contact_email
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
