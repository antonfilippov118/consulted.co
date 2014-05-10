class CancelsCall
  include LightService::Organizer

  def self.for(id, user)
    with(id: id, user: user).reduce [
      LookupCall,
      DetermineCancellable,
      CancelCall
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
      context.fail! 'User cannot cancel this!' unless user == call.expert || user == call.seeker
    end
  end

  class CancelCall
    include LightService::Action

    executed do |context|
      call = context.fetch :call
      begin
        call.status += 1
        call.save!
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
      user = context.fecth :user
      begin
        case call.status
        when Call::Status::DECLINED then send_decline_emails(call, user)
        when Call::Status::CANCELLED then send_cancellation_emails(call, user)
        else context.fail! 'Cannot cancel this call properly!'
        end
      rescue => e
        context.fail! e
      end
    end

    private

    def send_decline_emails(call, user)
      if user == call.expert
        CallMailer.call_declined_by_expert_to_seeker call
        CallMailer.call_declined_by_expert_manually call
      end
    end

    def send_cancellation_emails(call, user)
      if user == call.expert?
        CallMailer.call_cancelled_by_expert_to_seeker(call)
        CallMailer.call_cancelled_by_expert_to_expert(call)
      else
        CallMailer.call_cancelled_by_seeker_to_seeker(call)
        CallMailer.call_cancelled_by_seeker_to_expert(call)
      end
    end
  end
end
