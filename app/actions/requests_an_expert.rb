class RequestsAnExpert
  include LightService::Organizer

  def self.for(params)
    with(params: params).reduce [
      ClearParams,
      CreateRequest,
      SendExpertNotification
    ]
  end

  class ClearParams
    include LightService::Action

    executed do |context|
      params  = context.fetch :params
      expert  = params.fetch :expert
      user    = params.fetch :user
      start   = params.fetch :start
      length  = params.fetch :length
      offer   = params.fetch :offer
      message = params.fetch :message

      if expert.is_a? String
        expert = User.experts.find expert
      end

      context[:expert]       = expert
      context[:offer_id]     = offer.id.to_s
      context[:start]        = start
      context[:length]       = length
      context[:requested_by] = user.id.to_s
      context[:message]      = message
    end
  end

  class CreateRequest
    include LightService::Action

    executed do |context|
      expert  = context.fetch :expert
      request = expert.requests.create context.slice :requested_by, :offer_id, :start, :length, :message

      context[:request] = request
    end
  end

  class SendExpertNotification
    include LightService::Action

    executed do |context|
      mail = RequestMailer.request_notification context.slice :request, :expert
      begin
        mail.deliver!
      rescue  => e
        context.fail! e
      end
    end
  end
end
