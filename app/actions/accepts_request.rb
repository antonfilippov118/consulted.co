class AcceptsRequest
  include LightService::Organizer

  def self.for(id, user)
    with(id: id, user: user).reduce [
      FindCall,
      AcceptCall,
      GenerateTwilioCall,
      SendConfirmation
    ]
  end

  class FindCall
    include LightService::Action

    executed do |context|
      id = context.fetch :id
      user = context.fetch :user
      if id.is_a? Call
        request = id
      else
        request = Call.for(user).find id
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
         active_to: request.start + request.length.minutes,
         group: request.group
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
