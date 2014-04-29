class FindsOffers
  include LightService::Organizer

  def self.for(params, user = nil)
    with(params: params, user: user).reduce [
      FindGroup,
      FindExperts,
      FindOffers
      # ExcludeSelf
    ]
  end

  class FindGroup
    include LightService::Action

    executed do |context|
      begin
        params = context.fetch :params
        id     = params.fetch :group
        context[:group] = Group.find id
      rescue => e
        context.fail! e.message
      end
    end
  end

  class FindExperts
    include LightService::Action
    executed do |context|
      experts = User.experts
      context[:experts] = experts
    end
  end

  class FindOffers
    include LightService::Action

    executed do |context|
      experts = context.fetch :experts
      context[:offers] = experts.map(&:offers)
    end
  end

  class ExcludeSelf
    include LightService::Action

    executed do |context|
      user = context.fetch :user
      next context if user.nil?
      experts = context.fetch :experts

      experts = experts.where id: { :$ne => user.id }
      context[:experts] = experts
    end
  end
end
