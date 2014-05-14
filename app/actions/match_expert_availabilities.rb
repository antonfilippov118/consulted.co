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
        availabilities = Availability.future.with_date days
      else
        availabilities = Availability.future.next_days(14)
      end
      context[:expert_availabilities] = availabilities.group_by(&:user)
    end
  end

  class ExcludeExperts
    include LightService::Action

    executed do |context|
      mapping = context.fetch :expert_availabilities
      experts = context.fetch :experts
      mapping.reject do |expert, availabilities|
        availabilities.keep_if(&:call_possible?).any?
      end

      ids = mapping.map { |expert, availabilities| expert.id }
      context[:experts] = experts.where id: { :$in => ids }
    end
  end
end
