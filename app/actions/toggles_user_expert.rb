class TogglesUserExpert
  include LightService::Organizer

  def self.for(user)
    with(user: user).reduce [
      CheckActiveCalls,
      ToggleUser
    ]
  end

  class CheckActiveCalls
    include LightService::Action

    executed do |context|
      user = context.fetch :user

      # TODO: check for calls
      unless user.confirmed?
        context.fail! 'You cannot deactivate your profile while you have scheduled calls!'
      end
    end
  end

  class ToggleUser
    include LightService::Action

    executed do |context|
      user = context.fetch :user
      user.be_an_expert!
    end
  end
end
