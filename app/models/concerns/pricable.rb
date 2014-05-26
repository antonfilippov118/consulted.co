module Pricable
  module Call
    extend ActiveSupport::Concern

    def calc_rate!
      return if offer.nil?
      cost = ((offer.rate * length / 60))
      self.initial_rate      = offer.rate
      self.initial_rate_excl = offer.rate - (offer.rate.to_f * Settings.platform_fee / 100)
      self.fee  = (cost * Settings.platform_fee.to_f / 100) * 100
      self.rate = (cost * 100 - fee)
      self.cost = cost * 100
    end

    included do
      field :rate, type: Integer
      field :fee, type: Integer
      field :cost, type: Integer
      field :initial_rate, type: Integer
      field :initial_rate_excl, type: Integer

      before_create :calc_rate!

    end
  end
end
