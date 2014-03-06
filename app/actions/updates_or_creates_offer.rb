class UpdatesOrCreatesOffer
  include LightService::Organizer

  def self.for(user, params)
    with(user: user, params: params).reduce [
      LoadGroup,
      FindOffer,
      SaveOffer
    ]
  end

  class LoadGroup
    include LightService::Action
    executed do |context|
      params = context.fetch :params
      id     = params[:group][:id]
      begin
        context[:group] = Group.find id
      rescue => e
        context.fail! e
      end
    end
  end

  class FindOffer
    include LightService::Action
    executed do |context|
      group  = context.fetch :group
      user   = context.fetch :user
      offer  = user.offers.with_group(group)

      context[:offer] = offer
    end
  end

  class SaveOffer
    include LightService::Action

    executed do |context|
      offer  = context.fetch :offer
      user   = context.fetch :user
      params = context.fetch :params

      begin
        if offer.exists?
          offer = offer.first
          offer.update_attributes! params
        else
          user.offers.create! params
        end
      rescue => e
        context.fail! e
      end
    end
  end
end
