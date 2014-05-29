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
        'notification_time' => notification_time,
        'expert_page'       => expert_page
      }
    end

    def expert_page
      return false unless expert?
      return false unless Rails.env.production?
      "https://beta.consulted.co/#{slug}"
    end
  end
end
