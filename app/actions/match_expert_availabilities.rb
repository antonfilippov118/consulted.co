class MatchExpertAvailabilities
  include LightService::Organizer

  def self.for(experts, days = [])
    with(experts: experts, days: days).reduce [
      FindAvailabilities,
      ExcludeExperts
    ]
  end

  class FindAvailabilities
    include LightService::Action
    executed do |context|
      days = context.fetch :days
      if days.any?
        availabilities = Availability.with_date days
      else
        availabilities = Availability.next_days(14)
      end
      context[:expert_availabilities] = availabilities.group_by(&:user)
    end
  end

  class ExcludeExperts
    include LightService::Action

    executed do |context|
      mapping = context.fetch :expert_availabilities
      mapping.reject do |expert, availabilities|
        rest = availabilities.keep(&:blocks_available?)
        rest.any?
      end
      # assign expert ids with availabilities left
    end
  end
end
