class RequestsAnExpert
  include LightService::Organizer

  def self.for(params)
    with(params: params).reduce [
      ClearParams,
      CheckCallAvailability,
      CreateRequest,
      SendExpertNotification,
      SendSeekerNotification
    ]
  end

  class ClearParams
    include LightService::Action

    executed do |context|
      begin
        params  = context.fetch :params
        expert  = params.fetch :expert
        seeker  = params.fetch :seeker
        active  = params.fetch :active_from
        length  = params.fetch :length
        offer   = params.fetch :offer
        message = params.fetch :message

        if expert.is_a? String
          expert = User.experts.find expert
        end

        context[:expert]      = expert
        context[:offer]       = expert.offers.find(offer)
        context[:length]      = length
        context[:seeker]      = seeker
        context[:message]     = message
        context[:active_from] = DateTime.parse active
      rescue => e
        context.fail! e
      end
    end
  end

  class CheckCallAvailability
    include LightService::Action

    executed do |context|

    end
  end

  class CreateRequest
    include LightService::Action

    executed do |context|
      context[:call] = Call.create context.slice(:seeker, :expert, :offer, :length, :message, :active_from)
    end
  end

  class SendExpertNotification
    include LightService::Action

    executed do |context|
      call    = context.fetch(:call)
      mail    = RequestMailer.expert_notification call
      begin
        mail.deliver
      rescue => e
        context.fail! e
      end
    end
  end

  class SendSeekerNotification
    include LightService::Action

    executed do |context|
      mail = RequestMailer.seeker_notification context.fetch(:call)
      begin
        mail.deliver
      rescue => e
        context.fail! e
      end
    end
  end
end
