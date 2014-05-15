class MatchExpertAvailabilities
  include LightService::Organizer

  def self.for(experts, group, days = [])
    with(experts: experts, days: days, group: group).reduce [
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
      group   = context.fetch :group
      mapping.reject! do |expert, availabilities|
        offer = expert.offers.with_group(group).first
        time  = expert.next_possible_call offer
        !(availabilities.keep_if { |a| a.call_possible?(offer) }.any? && !!time)
      end

      ids = mapping.map { |expert, availabilities| expert.id }
      context[:experts] = experts.where id: { :$in => ids }
    end
  end
end
