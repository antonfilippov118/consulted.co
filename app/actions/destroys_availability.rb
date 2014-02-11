class DestroysAvailability
  include LightService::Organizer

  def self.for(user, id)
    with(user: user, id: id).reduce [
      FindAvailability,
      DestroyAvailability
    ]
  end

  class FindAvailability
    include LightService::Action

    executed do |context|
      id   = context.fetch :id
      user = context.fetch :user

      begin
        context[:availability] = Availability.for(user).find id
        next context
      rescue
        context.set_failure! 'Document not found!'
      end
    end
  end

  class DestroyAvailability
    include LightService::Action

    executed do |context|
      begin
        context[:availability].destroy!
      rescue
        context.set_failure! 'Could not remove availability!'
      end
    end
  end
end
