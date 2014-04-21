class SynchronizeLinkedinProfile
  include LightService::Organizer

  def self.for(id)
    with(id: id).reduce [
      LoadUser,
      SynchNetwork,
      SynchCountry,
      SynchCareer,
      SynchEducation,
      SynchImage,
      SynchUrl,
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

  class SynchCountry
    include LightService::Action
    executed do |context|
      client = context.fetch :client
      info   = client.profile fields: 'location'
      context[:user].country = Country.new(info.location.country.code).name
    end
  end

  class SynchCareer
    include LightService::Action

    executed do |context|
      client    = context.fetch :client
      user      = client.profile fields: %w(positions last-name first-name summary)
      name      = "#{user.first_name} #{user.last_name}"
      summary   = user.summary

      if user.positions.all.nil?
        companies = []
      else
        companies = user.positions.all.map do |p|
          params = {
            name: p.company['name'],
            linkedin_id: p.company['id'],
            industry: p.company['industry'],
            position: p.title,
            from: p.start_date.year,
            current: p.is_current
          }
          unless p.is_current
            params.merge! to: p.end_date.year
          end

          User::LinkedinCompany.new params
        end
      end
      context[:user].name      = name
      context[:user].companies = companies
      context[:user].summary   = summary
    end
  end

  class SynchEducation
    include LightService::Action

    executed do |context|
      client     = context.fetch :client
      user       = client.profile fields: 'educations'

      if user.educations.all.nil?
        educations = []
      else
        educations = user.educations.all.map do |education|
          params = {
            degree: education.degree,
            name: education.school_name,
            field: education.field_of_study,
            notes: education.notes
          }
          unless education.end_date.nil?
            params.merge! to: education.end_date.year
          end
          unless education.start_date.nil?
            params.merge! to: education.start_date.year
          end
          User::LinkedinEducation.new params
        end
      end
      context[:user].educations = educations
    end
  end

  class SynchImage
    include LightService::Action

    executed do |context|
      client = context.fetch :client
      url    = client.profile(fields: 'picture-urls::(original)').fetch(:'picture-urls').all
      next context if url.nil?
      image  = SynchronizeLinkedinProfile.retrieve url.first
      context[:user].profile_image = image
    end
  end

  class SynchUrl
    include LightService::Action

    executed do |context|
      client = context.fetch :client
      url    = client.profile(fields: 'public-profile-url').fetch :public_profile_url
      next context if url.nil?
      context[:user].user_linkedin_connection.public_profile_url = url
    end
  end

  class SaveUser
    include LightService::Action

    executed do |context|
      user = context.fetch :user
      user.user_linkedin_connection.last_synchronization = Time.now
      if user.save
        next context
      else
        context.fail! 'User Profile data could not be saved!'
      end
    end
  end

  private

  API_KEY = ENV['LINKEDIN_APIKEY']
  SECRET_KEY = ENV['LINKEDIN_SECRETKEY']

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
