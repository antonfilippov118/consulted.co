# encoding: utf-8

# responsible for authenticating the user
class AuthenticatesUser
  include LightService::Organizer

  def self.check(data)
    with(data: data).reduce [
      CheckExistenceAction
    ]
  end

  class CheckExistenceAction
    include LightService::Action

    executed do |context|
      data = context.fetch(:data)
      begin
        context[:user] = User.find_by(email: Regexp.new(data[:email], Regexp::IGNORECASE))
      rescue => e
        context.set_failure! e
      end
    end
  end
end
