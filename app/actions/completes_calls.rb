class CompletesCalls
  include LightService::Organizer

  def self.do
    with({}).reduce [
      FindCalls,
      CompleteCalls
    ]
  end

  class FindCalls
    include LightService::Action

    executed do |context|
      context[:calls] = Call.active.where active_to: { :$lte => Time.now - 30.minutes }
    end
  end

  class CompleteCalls
    include LightService::Action

    executed do |context|
      calls = context.fetch :calls
      calls.each(&:complete!)
    end
  end
end
