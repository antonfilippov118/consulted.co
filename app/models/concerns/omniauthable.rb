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
      if self.providers.nil?
        self.providers = [auth.provider]
      else
        self.providers += [auth.provider]
      end
      self.uid       = auth.uid
      self.email     = auth.info.email
      self.name      = auth.info.name
      self.password = Devise.friendly_token[0, 20] if self.password.nil?
      self.user_linkedin_connection = User::LinkedinConnection.new(token: auth['extra']['access_token'].token, secret: auth['extra']['access_token'].secret)

      unless save
        return false
      end
      synchronize_linkedin
      true
    end

    def disconnect_from_linkedin!
      self.providers.delete "linkedin"
      self.uid = nil
      self.user_linkedin_connection = nil
      save!
    end

    def synchronize_linkedin
      result = SynchronizeLinkedinProfile.for id
    end
  end
end
