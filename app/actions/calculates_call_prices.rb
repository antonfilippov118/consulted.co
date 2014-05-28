class CalculatesCallPrices
  include LightService::Organizer
  def self.for(call)
    with(call: call).reduce [
      CalculatePriceWithFee,
      CalculatePriceWithoutFee
    ]
  end

  class CalculatePriceWithFee
    include LightService::Action

    executed do |context|
      call =  context.fetch :call
      if call.length == 60
        context[:price_incl_fee] = call.initial_rate.to_f
        next
      end
      context[:price_incl_fee] = (call.initial_rate.to_f / 60 * call.length).round 2
    end
  end

  class CalculatePriceWithoutFee
    include LightService::Action

    executed do |context|
      call =  context.fetch :call
      context[:price_excl_fee] = ((call.initial_rate - call.initial_rate * percentage) / 60 * call.length).round 2
    end

    private

    def self.percentage
      Settings.platform_fee.to_f / 100
    end
  end
end
