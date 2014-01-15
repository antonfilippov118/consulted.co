module Omniauthable
  module Lookups
    extend ActiveSupport::Concern

    module ClassMethods
      def find_for_linkedin_oauth(auth)
        where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
          user.provider = auth.provider
          user.uid = auth.uid
          user.email = auth.info.email
          user.name  = auth.info.name
          user.password = Devise.friendly_token[0, 20]
          user.save!
        end
      end
    end
  end
end
