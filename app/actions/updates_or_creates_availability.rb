class UpdatesOrCreatesAvailability
  include LightService::Organizer

  def self.for(user, params)
    with(user: user, params: params).reduce [
      ValidatesConfirmation,
      ValidatesExpert,
      FindOrCreateAvailability,
      SaveAvailability
    ]
  end

  private

  class ValidatesConfirmation
    include LightService::Action

    executed do |context|
      user = context.fetch :user
      unless user.confirmed?
        context.set_failure! 'User must be confirmed!'
      end
    end
  end

  class ValidatesExpert
    include LightService::Action

    executed do |context|
      user = context.fetch :user
      unless user.confirmed?
        context.set_failure! 'User must be confirmed!'
      end
    end
  end

  class FindOrCreateAvailability
    include LightService::Action

    executed do |context|
      user = context.fetch :user
      params = context.fetch :params

      begin
        opts = {
          starts: params['starts'],
          ends: params['ends'],
          recurring: params['recurring'],
          user: user
        }
        if params['new_event'] == true
          availability = Availability.new opts
        else
          availability = Availability.for(user).find params['id']
          availability.assign_attributes opts
        end
      rescue
        context.set_failure! 'Document could not be found!'
      end
      context[:availability] = availability
      next context
    end
  end

  class SaveAvailability
    include LightService::Action
    executed do |context|
      availability = context.fetch :availability

      unless availability.save
        context.set_failure! 'Availability could not be saved!'
      end
    end
  end
end
