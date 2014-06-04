class FindsTheRightExpert
  include LightService::Organizer

  def self.for(params)
    offer, user = [:offer, :user].map { |sym| params.fetch sym }
    with(offer: offer, user: user).reduce [
      FindGroup,
      SendNotification
    ]
  end

  class FindGroup
    include LightService::Action

    executed do |context|
      slug = context.fetch :offer
      context[:group] = Group.find slug
    end
  end

  class SendNotification
    include LightService::Action

    executed do |context|
      user = context.fetch :user
      group = context.fetch :group
      begin
        mailer.find_expert_request(group, user).deliver!
      rescue => e
        context.fail! e.message
      end
    end

    def self.mailer
      ContactMailer
    end
  end
end
