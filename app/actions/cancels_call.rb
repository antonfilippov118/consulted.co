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
        call.status = Call::Status::CANCELLED
        call.save!
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
      CallMailer.expert_cancellation(call).deliver
    end
  end
end
