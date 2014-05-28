class UpdatesOrCreatesAvailability
  include LightService::Organizer

  def self.for(user, params)
    with(user: user, params: params).reduce [
      ConvertTimes,
      FindAvailability,
      SaveAvailability
    ]
  end

  private

  class ConvertTimes
    include LightService::Action
    executed do |context|
      params = context.fetch :params
      begin
        start  = params[:start]
        ending = params[:end]
        fail 'need start and end for availability!' if start.nil? || ending.nil?
        context[:start] = Time.at(start.to_i)
        context[:end]   = Time.at(ending.to_i)
      rescue => e
        context.fail! e.message
      end
    end
  end

  class FindAvailability
    include LightService::Action

    executed do |context|
      params = context.fetch :params
      id     = params[:id]
      user   = context.fetch :user

      if id.nil?
        availability = user.availabilities.new
      else
        begin
          availability = Availability.for(user).find id
        rescue Mongoid::Errors::DocumentNotFound
          availability = user.availabilities.new
        end
      end
      context[:availability] = availability
    end
  end

  class SaveAvailability
    include LightService::Action

    executed do |context|
      start        = context.fetch :start
      ending       = context.fetch :end
      availability = context.fetch :availability
      availability.start = start
      availability.end   = ending

      begin
        availability.save!
        context[:availability] = availability
      rescue => e
        context.fail! e.message
      end
    end
  end
end
