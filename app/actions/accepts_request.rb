class AcceptsRequest
  include LightService::Organizer

  def self.for(id)
    with(id: id).reduce [
      FindRequest,
      AcceptRequest,
      GenerateTwilioAccess,
      SendConfirmation
    ]
  end

  class FindRequest
    include LightService::Action

    executed do |context|

    end
  end
  class AcceptRequest
    include LightService::Action

    executed do |context|

    end
  end

  class GenerateTwilioAccess
    include LightService::Action

    executed do |context|

    end
  end

  class SendConfirmation
    include LightService::Action

    executed do |context|

    end
  end

end
