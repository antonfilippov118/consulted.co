class Users::ProfileController < Devise::SessionsController
  before_filter :authenticate!
  skip_before_filter :authenticate_scope!, except: []

  def show
    show_user
  end

  def synch_linkedin
    SynchsLinkedin.for current_user
    show_user
  end

  def update
    if current_user.update_attributes update_params
      render json: { success: true }, status: 200
    else
      render status: 422, json: {
        errors: current_user.errors.full_messages
      }
    end
  end

  private

  def authenticate!
    fail! unless warden.authenticate? scope: resource_name
  end

  def fail!
    render json: { error: 'Access denied!' }, status: 401
  end

  def show_user
    render json: {
      email: current_user.email,
      name: current_user.name,
      confirmed: current_user.confirmed?,
      linkedin: current_user.linkedin?,
      can_be_an_expert: current_user.can_be_an_expert?,
      reminder_time: current_user.reminder_time,
      languages: current_user.languages
    }
  end

  def update_params
    params.permit :name, :newsletter, :email, :reminder_time, languages: []
  end
end
