module Omniauthable
  module Lookups
    extend ActiveSupport::Concern

    module ClassMethods
      def find_for_linkedin_oauth(auth)
        where(auth.slice(:providers, :uid)).first_or_initialize.tap do |user|
          if user.providers.nil?
            user.providers = [auth.providers]
          else
            user.providers += [auth.providers]
          end
          user.uid = auth.uid
          user.email = auth.info.email
          user.name  = auth.info.name
          user.password = Devise.friendly_token[0, 20]
          user.save
        end
      end
    end
  end

  module Linkedin
    def connect_to_linkedin(auth)
      self.providers += [auth.provider]
      self.uid = auth.uid
      self.user_linkedin_connection = User::LinkedinConnection.new(token: auth['extra']['access_token'].token, secret: auth['extra']['access_token'].secret)

      User.synchonize_linkedin id
      unless save
        return false
      end
      true
    end

    def disconnect_from_linkedin!
      self.providers.delete "linkedin"
      self.uid = nil
      self.user_linkedin_connection = nil
      save!
    end
  end
end
