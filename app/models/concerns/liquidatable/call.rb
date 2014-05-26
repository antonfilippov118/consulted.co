module Liquidatable
  module Call
    extend ActiveSupport::Concern

    def to_liquid
      {
        'message' => message,
        'seeker' => seeker,
        'expert' => expert,
        'duration' => length,
        'code' => pin,
        'group' => name,
        'name' => name
      }.merge(languages).merge rates
    end

    def languages
      {
        'languages' => expert.languages.map(&:capitalize).join(', ')
      }
    end

    def rates
      {
        'price_incl_fee' => (rate + fee).to_f / 100,
        'price_excl_fee' => payment,
        'rate_incl_fee' => initial_rate,
        'rate_excl_fee' => initial_rate_excl
      }
    end
  end
end
