class ShowsAvailabilities
  include LightService::Organizer

  def self.for(user, week)
    with(user: user, week: week).reduce [
      ValidatesExpert,
      FetchAvailabilities,
      SortAvailabilities
    ]
  end

  class ValidatesExpert
    include LightService::Action
    executed do |context|
      user = context.fetch :user
      if user.can_be_an_expert?
        next context
      end
      context[:status] = :unprocessable_entity
      context.set_failure! 'User must be an expert!'
    end
  end

  class FetchAvailabilities
    include LightService::Action
    executed do |context|
      week = context.fetch :week
      user = context.fetch :user
      context[:availabilities] = Availability.for(user).in_week(week)
      next context
    end
  end

  class SortAvailabilities
    include LightService::Action
    executed do |context|
      next context
    end
  end
end
