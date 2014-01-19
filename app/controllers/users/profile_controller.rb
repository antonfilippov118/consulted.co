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
      can_be_an_expert: current_user.can_be_an_expert?
    }
  end
end
