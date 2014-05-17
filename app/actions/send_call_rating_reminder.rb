class SendCallRatingReminder
  include LightService::Organizer

  def self.do
    with({}).reduce [
      FindCalls,
      SendNotifications
    ]
  end

  private

  class FindCalls
    include LightService::Action

    executed do |context|
      context[:calls] = Call.completed.where active_to: { :$lte => Time.now - 24.hours }, rating_reminder_sent: false
    end
  end

  class SendNotifications
    include LightService::Action

    executed do |context|
      calls = context.fetch :calls
      calls.each do |call|
        mail = CallMailer.call_followup_to_seeker(call)
        mail.deliver!
        call.rating_reminder_sent    = true
        call.rating_reminder_sent_at = Time.now
        call.save
      end
    end
  end
end
