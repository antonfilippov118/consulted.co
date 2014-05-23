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
      experts = context.fetch(:experts).map(&:id)
      availabilities = Availability.for(experts).future.next_days(14)
      context[:experts_available] = availabilities.map(&:user).uniq
    end
  end

  class ExcludeExperts
    include LightService::Action

    def self.select_time(expert_times, times, days, user = nil)
      expert_times.keep_if do |expert_time|
        starting, ending = [:start, :end].map { |sym| Time.at(expert_time.fetch(sym)) }
        unless user.nil?
          starting, ending = [starting, ending].map { |time| time.in_time_zone(user.timezone) }
        end
        self.match_time?(starting, ending, times) && self.match_days?(starting, days)
      end
    end

    def self.match_days?(date, days)
      return true if days.empty?
      days.map do |day|
        date.day == Date.parse(day).day
      end.include? true
    end

    def self.match_time?(starting, ending, times)
      return true if times.empty?
      times.map do |time|
        from, to = [:from, :to].map { |sym| time.fetch sym }
        next ending.hour <= to if from == 0
        next from <= starting.hour if to == 0
        ((from..to).to_a & (starting.hour..ending.hour).to_a).any?
      end.include? true
    end

    executed do |context|
      experts_available = context.fetch :experts_available
      begin
        experts = context.fetch :experts
        group   = context.fetch :group
        times   = context.fetch :times
        user    = context.fetch :user
        days    = context.fetch :days

        # reject experts which do not have times available
        experts_available.reject! do |expert|
          offer = expert.offers.with_group(group).first
          result = FindsExpertTimes.for expert, offer.minimum_length.minutes
          possible_times = result.fetch :times
          expert.possible_times = possible_times
          next true if possible_times.empty?
          filtered_times = ExcludeExperts.select_time expert.possible_times, times, days, user
          filtered_times.empty?
        end

        ids = experts_available.map { |expert| expert.id }
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
