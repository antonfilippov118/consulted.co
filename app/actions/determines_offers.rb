class DeterminesOffers
  include LightService::Organizer

  def self.for(group)
    with(group: group).reduce [
      FindOffers,
      MapValues
    ]
  end

  class FindOffers
    include LightService::Action

    executed do |context|
      group = context.fetch :group
      context[:offers] = Offer.valid.with_group group
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
