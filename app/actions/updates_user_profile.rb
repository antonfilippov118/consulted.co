class UpdatesUserProfile
  include LightService::Organizer

  def self.with_params(user, params = {})
    with(user: user, params: params).reduce [
      UpdateUser
    ]
  end

  class UpdateUser
    include LightService::Action

    executed do |context|
      user   = context.fetch :user
      params = context.fetch :params

      unless user.update_attributes params
        context[:errors] = user.errors
        context.set_failure!
      end
    end
  end
end
