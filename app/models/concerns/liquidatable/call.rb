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
        'price_incl_fee' => prices.fetch(:price_incl_fee),
        'price_excl_fee' => prices.fetch(:price_excl_fee),
        'rate_incl_fee' => initial_rate,
        'rate_excl_fee' => initial_rate_excl,
        'cancellation_fee' => fees.fetch(:fee)
      }
    end

    def prices
      CalculatesCallPrices.for self
    end

    def fees
      CalculatesCallFee.for self
    end
  end
end
