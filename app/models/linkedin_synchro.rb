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

    user.linkedin_network = client.connections['total']
    user.save
  end

  def self.synch_name(user)
    client = authorize user
    user.name = "#{client.profile['first_name']} #{client.profile['last_name']}"
    user.save
  end
end
