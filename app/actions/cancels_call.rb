class CancelsCall
  include LightService::Organizer

  def self.for(id, user)
    with(id: id, user: user).reduce [
      LookupCall,
      DetermineCancellable,
      CancelCall,
      SendNotifications,
      SaveCall
    ]
  end

  class LookupCall
    include LightService::Action

    executed do |context|
      id = context.fetch :id
      if id.is_a? Call
        call = id
      else
        begin
          call = Call.find id
        rescue => e
          context.fail! e
        end
      end
      context[:call] = call
    end
  end

  class DetermineCancellable
    include LightService::Action

    executed do |context|
      call = context.fetch :call
      user = context.fetch :user
      context.fail! 'This call cannot be cancelled!' unless call.cancellable?
      context.fail! 'User cannot cancel this!' unless user == call.expert || user == call.seeker
    end
  end

  class CancelCall
    include LightService::Action

    executed do |context|
      call = context.fetch :call
      begin
        call.status += 1
        context[:call] = call
      rescue => e
        context.fail! e.message
      end
    end
  end

  class SendNotifications
    include LightService::Action

    # TODO: depending on who cancelled different emails have to be sent
    executed do |context|
      call = context.fetch :call
      user = context.fetch :user
      begin
        case call.status
        when Call::Status::DECLINED then SendNotifications.decline_emails(call, user).each(&:deliver!)
        when Call::Status::CANCELLED then SendNotifications.cancellation_emails(call, user).each(&:deliver!)
        else context.fail! 'Cannot cancel this call properly!'
        end
      rescue => e
        context.fail! e
      end
    end

    def self.decline_emails(call, user)
      if user == call.expert
        [
          CallMailer.call_declined_by_expert_to_seeker(call),
          CallMailer.call_declined_by_expert_manually(call)
        ]
      else
        []
      end
    end

    def self.cancellation_emails(call, user)
      return SendNotification.expert_cancelled(call) if user == call.expert?
      SendNotifications.seeker_cancelled(call)
    end

    def self.expert_cancelled(call)
      [
        CallMailer.call_cancelled_by_expert_to_seeker(call),
        CallMailer.call_cancelled_by_expert_to_expert(call)
      ]
    end

    def self.seeker_cancelled(call)
      [
        CallMailer.call_cancelled_by_seeker_to_seeker(call),
        CallMailer.call_cancelled_by_seeker_to_expert(call)
      ]
    end
  end

  class SaveCall
    include LightService::Action

    executed do |context|
      call = context.fetch :call

      begin
        call.save!
      rescue => e
        context.fail! e.message
      end
    end
  end
end
