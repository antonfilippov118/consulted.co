module Liquidatable
  module User
    extend ActiveSupport::Concern

    def to_liquid
      {
        'name'              => name,
        'first_name'        => first_name,
        'last_name'         => last_name,
        'email'             => email,
        'linkedin'          => linkedin_url,
        'twitter'           => twitter_url,
        'notification_time' => notification_time
      }
    end
  end
end
