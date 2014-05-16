class MatchExpertAvailabilities
  include LightService::Organizer

  def self.for(options = {})
    options = defaults.merge options
    with(options).reduce [
      FindAvailabilities,
      ExcludeExperts
    ]
  end

  class FindAvailabilities
    include LightService::Action
    executed do |context|
      days  = context.fetch :days
      experts = context.fetch(:experts).map(&:id)
      if days.any?
        availabilities = Availability.for(experts).future.with_date days
      else
        availabilities = Availability.for(experts).future.next_days(14)
      end

      context[:expert_availabilities] = availabilities.group_by(&:user)
    end
  end

  class ExcludeExperts
    include LightService::Action

    def self.fits(time, times, user = nil)
      time  = Time.at(time).in_time_zone(user.timezone) unless user.nil?
      value = time.hour.to_f + time.min.to_f / 60

      times.map do |obj|
        obj[:from] <= value && value <= obj[:to]
      end.include? true
    end

    executed do |context|
      mapping = context.fetch :expert_availabilities
      begin
        experts = context.fetch :experts
        group   = context.fetch :group
        times   = context.fetch :times
        user    = context.fetch :user
        # reject everything not possible to call
        mapping.reject! do |expert, availabilities|
          offer = expert.offers.with_group(group).first
          time  = expert.next_possible_call offer
          !(availabilities.keep_if { |a| a.call_possible?(offer) }.any? && !!time)
        end

        # reject experts which do not fit the time filter
        if times.any?
          mapping.reject! do |expert, availabilities|
            offer = expert.offers.with_group(group).first
            possible_times = expert.next_times offer
            possible_times = possible_times.select { |time| ExcludeExperts.fits time, times, user }
            possible_times.empty?
          end
        end

        ids = mapping.map { |expert, availabilities| expert.id }
      rescue => e
        context.fail! e.message
        ids = []
      end

      context[:experts] = experts.where id: { :$in => ids }
    end

  end

  def self.defaults
    {
      experts: [],
      times: [],
      days: [],
      group: Group.new(name: 'Default'),
      user: nil
    }
  end
end
