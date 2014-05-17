class SendCallReminders
  include LightService::Organizer

  def self.do
    with({}).reduce [
      FindCalls,
      SendNotifications
    ]
  end

  class FindCalls
    include LightService::Action

    executed do |context|
      context[:calls] = Call.active.any_of({ expert_reminder_sent: false }, { seeker_reminder_sent: false })
    end
  end

  class SendNotifications
    include LightService::Action

    def self.expert!(call)
      self.send!(call, :expert)
    end

    def self.seeker!(call)
      self.send!(call, :seeker)
    end

    executed do |context|
      calls = context.fetch :calls

      calls.each do |call|
        unless call.expert_reminder_sent?
          time = call.active_from - call.expert.notification_time.minutes
          if time <= Time.now
            SendNotifications.expert! call
            call.expert_reminder_sent = true
            call.expert_reminder_sent_at = Time.now
          end
        end

        unless call.seeker_reminder_sent?
          time = call.active_from - call.seeker.notification_time.minutes
          if time <= Time.now
            SendNotifications.seeker! call
            call.seeker_reminder_sent    = true
            call.seeker_reminder_sent_at = Time.now
          end
        end
        call.save if call.changed?
      end
    end

    private

    def self.send!(call, sym)
      if sym == :seeker
        mail = CallMailer.call_reminder_to_seeker call
      else
        mail = CallMailer.call_reminder_to_expert call
      end
      mail.deliver!
    end
  end
end
