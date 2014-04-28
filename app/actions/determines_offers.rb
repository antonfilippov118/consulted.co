class DeterminesOffers
  include LightService::Organizer

  def self.for(group)
    with(group: group).reduce [
      FindExperts,
      FindOffers,
      MapValues
    ]
  end

  class FindExperts
    include LightService::Action

    executed do |context|
      group = context.fetch :group
      context[:experts] = User.experts.with_group group
    end
  end

  class FindOffers
    include LightService::Action

    executed do |context|
      group = context.fetch :group
      experts = context.fetch :experts

      context[:offers] = experts.map do |expert|
        expert.offers.where(group: group).first
      end
    end
  end

  class MapValues
    include LightService::Action

    executed do |context|
      offers = context.fetch :offers
      if offers.any?
        rates = offers.map(&:rate)
        experience = offers.map(&:experience)
      else
        rates = []
        experience = []
      end

      context[:rates] = rates
      context[:experience] = experience
    end
  end
end
