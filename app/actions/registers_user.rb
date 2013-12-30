class RegistersUser
  include LightService::Organizer
  def self.for_new(user)
    with(user: user).reduce [
      ValidatesUserAction,
      SavesUserAction
    ]
  end

  class ValidatesUserAction
    include LightService::Action

    executed do |context|
      user = context.fetch :user
      next context.set_failure! "User is invalid!" unless user.valid?
    end
  end

  class SavesUserAction
    include LightService::Action
    executed do |context|
      user = context.fetch :user
      begin
        user.save!
      rescue Exception => e
        next context.set_failure! e
      end
    end
  end
end
