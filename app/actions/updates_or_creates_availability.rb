class UpdatesOrCreatesAvailability
  include LightService::Organizer

  def self.for(user, params)
    with(user: user, params: params).reduce [
      FindOrCreateAvailability,
      SaveAvailability
    ]
  end

  private

  class FindOrCreateAvailability
    include LightService::Action

    executed do |context|
      user = context.fetch :user
      params = context.fetch :params

      begin
        opts = {
          starts: params[:starts],
          ends: params[:ends],
          recurring: params[:recurring]
        }

        if params[:new_event] == true
          availability = user.availabilities.new opts
        else
          availability = user.availabilities.find params[:id]
          availability.assign_attributes opts
        end
      rescue
        context.fail! 'Document could not be found!'
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
        context.fail! 'Availability could not be saved!'
      end
    end
  end
end
