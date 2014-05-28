class CalculatesCallFee
  include LightService::Organizer

  def self.for(call)
    with(call: call).reduce [
      DetermineFee,
      CalculateFee
    ]
  end

  class DetermineFee
    include LightService::Action

    executed do |context|
      call = context.fetch :call
      unless call.cancelled?
        context[:fee] = 0
      end
    end
  end

  class CalculateFee
    include LightService::Action

    executed do |context|
      next if context[:fee] == 0
      call = context.fetch :call
      if call.cancelled_at + 24.hours < call.active_from
        percentage = 0.1
      else
        percentage = 0.5
      end
      context[:fee] = call.initial_rate * percentage
    end
  end
end
