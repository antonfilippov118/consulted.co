class AcceptsCall
  include LightService::Organizer

  def self.for(id, user)
    with(id: id, user: user).reduce [
      FindCall,
      AcceptCall,
      SendExpertConfirmation,
      SendSeekerConfirmation
    ]
  end

  class FindCall
    include LightService::Action

    executed do |context|
      begin
        id = context.fetch :id
        user = context.fetch :user
        if id.is_a? Call
          call = id
        else
          call = Call.for(user).find id
        end
        context[:call] = call
      rescue => e
        context.fail! e.message
      end
    end
  end

  class AcceptCall
    include LightService::Action

    executed do |context|
      begin
        call = context.fetch :call
        call.status = Call::Status::ACCEPTED
        call.confirmed_at = Time.now
        call.save!
        context[:call] = call
      rescue => e
        context.fail! e.message
      end
    end
  end

  class SendExpertConfirmation
    include LightService::Action

    executed do |context|
      call = context.fetch :call
      mail = CallMailer.expert_confirmation call
      begin
        mail.deliver!
      rescue => e
        context.fail! e.message
      end
    end
  end

  class SendSeekerConfirmation
    include LightService::Action

    executed do |context|
      call = context.fetch :call
      mail = CallMailer.seeker_confirmation call
      begin
        mail.deliver!
      rescue => e
        context.fail! e.message
      end
    end
  end

end
