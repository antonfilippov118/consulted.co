class Users::ProfileController < Devise::SessionsController
  before_filter :authenticate!
  skip_before_filter :authenticate_scope!, except: []

  def show
    show_user
  end

  def synch_linkedin
    LinkedinSynchro.synch_contacts current_user
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
      linkedin_profile: current_user.provider == 'linkedin',
      can_be_an_expert: current_user.linkedin_contacts >= 1
    }
  end

  class LinkedinSynchro
    API_KEY = '778ilmargr3n73'
    SECRET_KEY = 'GZdkA1QdBbuc8GVm'

    def self.authorize(user)
      token = user.user_linkedin_connection.token
      secret = user.user_linkedin_connection.secret

      client = LinkedIn::Client.new(API_KEY, SECRET_KEY)
      client.authorize_from_access(token, secret)
      client
    end

    def self.synch_contacts(user)
      client = authorize user

      user.linkedin_contacts = client.connections['total']
      user.save
    end
  end
end
