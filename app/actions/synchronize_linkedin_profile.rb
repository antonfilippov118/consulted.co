class SynchronizeLinkedinProfile
  include LightService::Organizer

  def self.for(id)
    with(id: id).reduce [
      LoadUser,
      SynchNetwork,
      SynchCareer,
      SynchImage,
      SaveUser
    ]
  end

  class LoadUser
    include LightService::Action

    executed do |context|
      begin
        id     = context.fetch :id
        user   = User.find id
        client = SynchronizeLinkedinProfile.create_client user
        context[:client] = client
        context[:user] = user
      rescue => e
        context.fail! "User could not be loaded (#{e.message})!"
      end
    end
  end

  class SynchNetwork
    include LightService::Action

    executed do |context|
      client = context.fetch :client
      context[:user].linkedin_network = client.connections['total']
    end
  end

  class SynchCareer
    include LightService::Action

    executed do |context|
      client    = context.fetch :client
      user      = client.profile fields: %w(positions last-name first-name educations)
      name      = "#{user.first_name} #{user.last_name}"
      positions = user.positions.all.map { |p| p.title }
      companies = user.positions.all.map do |p|
        params = {
          name: p.company['name'],
          linkedin_id: p.company['id'],
          industry: p.company['industry']
        }
        User::LinkedinCompany.new params
      end
      context[:user].name      = name
      context[:user].positions = positions
      context[:user].companies = companies
    end
  end

  class SynchImage
    include LightService::Action

    executed do |context|
      client = context.fetch :client
      url    = client.profile(fields: 'picture-urls::(original)').fetch(:'picture-urls').all
      image  = SynchronizeLinkedinProfile.retrieve url.first
      context[:user].profile_image = image
    end

  end

  class SaveUser
    include LightService::Action

    executed do |context|
      user = context.fetch :user
      if user.save
        next context
      else
        context.fail! 'User Profile data could not be saved!'
      end
    end
  end

  private

  # TODO: move this to config
  API_KEY = '778ilmargr3n73'
  SECRET_KEY = 'GZdkA1QdBbuc8GVm'

  def self.create_client(user)
    client = LinkedIn::Client.new(API_KEY, SECRET_KEY)
    token  = user.user_linkedin_connection.token
    secret = user.user_linkedin_connection.secret
    client.authorize_from_access(token, secret)
    client
  end

  def self.retrieve(url)
    Dragonfly.app.fetch_url url
  end
end
