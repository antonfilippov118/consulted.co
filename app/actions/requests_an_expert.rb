class RequestsAnExpert
  include LightService::Organizer

  def self.for(params)
    with(params).reduce [
      CreateRequest
    ]
  end

  class CreateRequest
    include LightService::Action

    executed do |context|
      expert = context.fetch :expert
      user   = context.fetch :user
      start  = context.fetch :start
      length = context.fetch :length
      offer  = context.fetch :offer

      expert.requests.create user: user, start: start, offer: offer, length: length
    end
  end
end
