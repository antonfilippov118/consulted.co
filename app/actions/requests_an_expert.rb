class RequestsAnExpert
  include LightService::Organizer

  def self.for(params)
    with(params: params).reduce [
      ClearParams,
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
        length  = params.fetch :length
        offer   = params.fetch :offer
        message = params[:message]

        if expert.is_a? String
          expert = User.experts.find expert
        end

        context[:expert]   = expert
        context[:offer]    = expert.offers.find(offer)
        context[:length]   = length
        context[:seeker]   = seeker
        context[:message]  = message unless message.nil?
      rescue => e
        context.fail! e
      end
    end
  end

  class CreateRequest
    include LightService::Action

    executed do |context|
      expert  = context.fetch :expert
      request = expert.requests.create context.slice :seeker, :offer, :length, :message
      context[:request] = request
    end
  end

  class SendExpertNotification
    include LightService::Action

    executed do |context|
      mail = RequestMailer.notification context.fetch :request
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
      mail = RequestMailer.seeker_notification context.fetch :request
      begin
        mail.deliver
      rescue => e
        context.fail! e
      end
    end
  end
end
