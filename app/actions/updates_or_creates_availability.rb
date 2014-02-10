class UpdatesOrCreatesAvailability
  include LightService::Organizer

  def self.for(user, params)
    with(user: user, params: params).reduce [
      ValidatesConfirmation,
      ValidatesExpert,
      CreateAvailability
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

  class CreateAvailability
    include LightService::Action

    executed do |context|
      user = context.fetch :user
      params = context.fetch :params

      begin
        if params['new_event'] == true
          availability = Availability.new params['availability']
        else
          availability = Availability.find params['id']
        end
      rescue
        context.set_failure! 'Document could not be found!'
        next context
      end

      availability.user = user

      unless availability.save
        context[:errors] = availability.errors.full_messages
        context.set_failure! 'Availability is not valid!'
        next
      end
      context[:availability] = availability
    end
  end
end
