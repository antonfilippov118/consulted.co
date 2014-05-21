module Omniauthable
  module Lookups
    extend ActiveSupport::Concern

    module ClassMethods
      def find_for_linkedin_oauth(auth)
        where(auth.slice(:providers, :uid)).first_or_initialize
      end
    end

    included do
      index providers: 1, uid: 1
    end
  end

  module Twitter
    def twitter?
      twitter_handle.present?
    end

    def twitter_url
      return false unless twitter?
      "https://twitter.com/#{twitter_handle.gsub('@', '')}"
    end
  end

  module Linkedin
    def connect_to_linkedin(auth)
      return true unless user_linkedin_connection.nil?
      self.providers = providers.nil? ? [auth.provider] : [auth.provider]
      self.uid       = auth.uid
      self.name      = auth.info.name

      unless persisted?
        self.email     = auth.info.email
        self.password  = Devise.friendly_token[0, 20]
      end

      self.user_linkedin_connection = User::LinkedinConnection.new params(auth)
      save
    end

    def params(auth)
      {
        token: auth['extra']['access_token'].token,
        secret: auth['extra']['access_token'].secret,
        email: auth.info.email
      }
    end

    def disconnect_from_linkedin!
      providers.delete 'linkedin'
      self.uid = nil
      self.user_linkedin_connection = nil
      save!
    end

    def synchronize_linkedin
      SynchronizeLinkedinProfile.for id
    end

    def linkedin_email
      return false if user_linkedin_connection.nil?
      user_linkedin_connection.email
    end

    def linkedin_synchronized?
      return false if user_linkedin_connection.nil?
      !user_linkedin_connection.last_synchronization.nil?
    end

    def linkedin?
      return false if providers.nil?
      providers.include? 'linkedin'
    end

    def linkedin_url
      return false unless linkedin?
      return false if user_linkedin_connection.nil?
      user_linkedin_connection.public_profile_url
    end
  end
end
