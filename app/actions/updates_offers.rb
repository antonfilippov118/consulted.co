class UpdatesOffers
  include LightService::Organizer

  def self.for(user, params)
    with(user: user, params: params).reduce [
      ValidateConfirmation,
      ValidateExpert,
      CreateOffers
    ]
  end

  class ValidateConfirmation
    include LightService::Action

    executed do |context|
      user = context.fetch :user
      unless user.confirmed?
        context.set_failure! 'User must be confirmed!'
        context[:status] = :unprocessable_entity
        next context
      end
    end
  end

  class ValidateExpert
    include LightService::Action

    executed do |context|
      user = context.fetch :user
      unless user.can_be_an_expert?
        context.set_failure! 'User must be an expert!'
        context[:status] = :unprocessable_entity
        next context
      end
    end
  end

  class CreateOffers
    include LightService::Action

    executed do |context|
      user   = context.fetch :user
      params = context.fetch :params

      begin
        params.each do |offer_params|
          id   = offer_params.delete '_group_id'
          %W(name _id).each do |field|
            offer_params.delete field
          end
          o = user.offers.find_or_create_by group_id: id
          o.update_attributes offer_params
        end
      rescue => e
        context.set_failure! e
      end
    end
  end
end
