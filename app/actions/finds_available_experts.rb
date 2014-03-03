class FindsAvailableExperts
  include LightService::Organizer

  def self.for(group)
    with(group: group).reduce [
      FindAvailableUsers,
      FilterExpertsWithTime,
      RankExperts
    ]
  end

  class FindAvailableUsers
    include LightService::Action
    executed do |context|
      group   = context.fetch :group
      experts = User.experts.with_group group
      context[:experts] = experts
    end
  end

  class FilterExpertsWithTime
    include LightService::Action

    executed do |context|
      # TODO: implement this, when bookings are actually possible to filter experts with no time
    end
  end

  class RankExperts
    include LightService::Action

    executed do |context|
      # TODO: implement a ranking system
    end
  end
end
