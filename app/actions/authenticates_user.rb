# encoding: utf-8

# responsible for authenticating the user
class AuthenticatesUser
  include LightService::Organizer

  def self.check(data)
    with(data: data).reduce [
      CheckExistenceAction,
      CheckPasswordAction
    ]
  end

  class CheckExistenceAction
    include LightService::Action

    executed do |context|
      data = context.fetch(:data)
      begin
        requirements = {
          email: Regexp.new(Regexp.escape(data[:email]), Regexp::IGNORECASE),
          confirmed: true, active: true
        }
        context[:user] = User.find_by requirements
      rescue => e
        context.set_failure! e
      end
    end
  end

  class CheckPasswordAction
    include LightService::Action

    executed do |context|
      user = context.fetch :user
      data = context.fetch :data
      begin
        result = user.authenticate data[:password]
        fail UserPasswordException if result == false
      rescue => e
        context.set_failure! e
      end
    end

    class UserPasswordException < StandardError
    end
  end
end
