# encoding: utf-8

# registers a user
class RegistersUser
  include LightService::Organizer
  def self.for_new(data)
    with(user: data).reduce [
      ValidatesUserAction,
      SavesUserAction,
      SendsConfirmationEmailAction
    ]
  end

  # validates the data for a new record
  class ValidatesUserAction
    include LightService::Action

    executed do |context|
      user = context.fetch :user
      next context.set_failure! 'User is invalid!' unless user.valid?
    end
  end

  # saves the data to the database
  class SavesUserAction
    include LightService::Action
    executed do |context|
      user = context.fetch :user
      begin
        user.save!
      rescue => e
        next context.set_failure! e
      end
    end
  end

  # sends a confirmation email
  class SendsConfirmationEmailAction
    include LightService::Action

    executed do |context|
      user = context.fetch :user
      begin
        UserMailer.confirmation(user).deliver!
      rescue => e
        next context.set_failure! e
      end
    end
  end
end
