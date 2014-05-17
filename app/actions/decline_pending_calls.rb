class DeclinePendingCalls
  include LightService::Organizer

  def self.older_than(time)
    with(older: time).reduce [
      FindCalls,
      CancelCalls
    ]
  end

  class FindCalls
    include LightService::Action

    executed do |context|
      older = context.fetch :older
      context[:calls] = Call.requested.where created_at: { :$lte => Time.now - older }
    end
  end

  class CancelCalls
    include LightService::Action

    def self.notifications(call)
      seeker_mail = CallMailer.call_declined_by_expert_to_seeker call
      expert_mail = CallMailer.call_declined_by_expert_auto call
      [seeker_mail, expert_mail]
    end

    executed do |context|
      calls = context.fetch :calls
      calls.to_a.each do |call|
        begin
          call.decline!
          mails = CancelCalls.notifications call
          mails.each(&:deliver!)
        rescue => e
          context.fail! e.message
        end
      end
    end
  end
end
