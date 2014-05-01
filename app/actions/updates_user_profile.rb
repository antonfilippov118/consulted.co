class UpdatesUserProfile
  include LightService::Organizer

  def self.with_params(user, params = {})
    with(user: user, params: params).reduce [
      UpdateUser,
      UpdateOfferSlugs
    ]
  end

  class UpdateUser
    include LightService::Action

    executed do |context|
      user   = context.fetch :user
      params = context.fetch :params

      unless user.update_attributes params
        context[:errors] = user.errors
        context.fail! "Could not update profile! (#{user.errors.full_messages.join ", "})"
      end
    end
  end

  class UpdateOfferSlugs
    include LightService::Action

    executed do |context|
      params = context.fetch :params
      next context if params[:slug].nil?
      user = context.fetch :user
      user.offers.map(&:save)
    end
  end
end
