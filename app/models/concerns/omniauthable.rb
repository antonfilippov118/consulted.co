module Omniauthable
  module Lookups
    extend ActiveSupport::Concern

    module ClassMethods
      def find_for_linkedin_oauth(auth)
        where(auth.slice(:providers, :uid)).first_or_initialize
      end
    end
  end

  module Linkedin
    def connect_to_linkedin(auth)
      return true unless self.user_linkedin_connection.nil?
      self.providers = providers.nil? ? [auth.provider] : [auth.provider]
      self.uid       = auth.uid
      self.email     = auth.info.email
      self.name      = auth.info.name
      self.password  = Devise.friendly_token[0, 20] if password.nil?

      self.user_linkedin_connection = User::LinkedinConnection.new(token: auth['extra']['access_token'].token, secret: auth['extra']['access_token'].secret)

      return false unless save
      synchronize_linkedin unless linkedin_synchronized?
      true
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

    def linkedin_synchronized?
      return false if user_linkedin_connection.nil?
      !user_linkedin_connection.last_synchronization.nil?
    end
  end
end
