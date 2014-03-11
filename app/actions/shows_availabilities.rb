class ShowsAvailabilities
  include LightService::Organizer

  def self.for(user, week = nil)
    if week.nil?
      week = Date.today.cweek
    end

    with(user: user, week: week).reduce [
      FindAvailabilities,
      GroupAvailabilities
    ]
  end

  private

  class FindAvailabilities
    include LightService::Action

    executed do |context|
      user = context.fetch :user
      week = context.fetch :week

      availabilities = user.availabilities.in_week week
      recurring      = user.availabilities.recurring

      context[:availabilities] = (availabilities + recurring).uniq
    end
  end

  class GroupAvailabilities
    include LightService::Action

    executed do |context|
      availabilities = context.fetch :availabilities
      weeks = [[], [], [], [], [], [], []]
      availabilities.each do |availability|
        day = availability.starts.cwday
        weeks[day - 1] << availability
      end
      context[:availabilities] = weeks
    end
  end
end
