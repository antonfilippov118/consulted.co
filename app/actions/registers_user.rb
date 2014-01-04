class RegistersUser
  include LightService::Organizer
  def self.for_new(data)
    with(user: data).reduce [
      ValidatesUserAction,
      SavesUserAction,
      SendsConfirmationEmailAction
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

  class SendsConfirmationEmailAction
    include LightService::Action

    executed do |context|
      user = context.fetch :user
      begin
        UserMailer.confirmation(user).deliver!
      rescue Exception => e
        next context.set_failure! e
      end
    end
  end
end
