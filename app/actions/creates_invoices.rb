class CreatesInvoices
  include LightService::Organizer

  def self.do
    with({}).reduce [
                        FindCalls,
                        CreateInvoices
                    ]
  end

  class FindCalls
    include LightService::Action

    executed do |context|
      context[:calls] = Call.completed.without_invoice.where active_to: { :$lte => Time.now - 30.minutes - Settings.call_dispute_period.hours }
    end
  end

  class CreateInvoices
    include LightService::Action

    executed do |context|
      calls = context.fetch :calls
      calls.each(&:create_invoice)
    end
  end
end
