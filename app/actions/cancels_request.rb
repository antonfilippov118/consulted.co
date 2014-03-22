class CancelsRequest
  include LightService::Organizer

  def self.for(options = {})
    id   = options.fetch :id
    user = options.fetch :user
    with(id: id, user: user).reduce [
      LookupRequest,
      DetermineCancellable,
      CancelRequest,
      SendNotification
    ]
  end

  class LookupRequest
    include LightService::Action

    executed do |context|
      id = context.fetch :id
      begin
        request = Request.find id
      rescue => e
        context.fail! e
      end
      context[:request] = request
    end
  end

  class DetermineCancellable
    include LightService::Action

    executed do |context|
      request = context.fetch :request
      user    = context.fetch :user
      context.fail! 'User cannot cancel this!' if request.requested_by != user.id.to_s
    end
  end

  class CancelRequest
    include LightService::Action

    executed do |context|
      request = context.fetch :request
      request.cancel!
    end
  end

  class SendNotification
    include LightService::Action

    executed do |context|
      request = context.fetch :request
      RequestMailer.cancellation(request).deliver!
    end
  end
end
