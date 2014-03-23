class AcceptsRequest
  include LightService::Organizer

  def self.for(id)
    with(id: id).reduce [
      FindRequest,
      AcceptRequest,
      GenerateTwilioCall,
      SendConfirmation
    ]
  end

  class FindRequest
    include LightService::Action

    executed do |context|
      id = context.fetch :id
      if id.is_a? Request
        request = id
      else
        request = Request.find id
      end

      context[:request] = request
    end
  end

  class AcceptRequest
    include LightService::Action

    executed do |context|
      begin
        request = context.fetch :request
        request.accepted = true
        request.save!
      rescue => e
        context.fail! e
      end
    end
  end

  class GenerateTwilioCall
    include LightService::Action

    executed do |context|
      request = context.fetch :request
      params = {
         seeker: request.seeker,
         expert: request.expert,
         active_from: request.start,
         active_to: request.start + request.length.minutes
      }
      call = Call.new params

      unless call.save
        context[:errors] = call.errors
        context.fail! 'Call could not be scheduled!'
      end
      context[:call] = call
    end
  end

  class SendConfirmation
    include LightService::Action

    executed do |context|

    end
  end

end
