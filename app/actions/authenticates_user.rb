# encoding: utf-8

# responsible for authenticating the user
class AuthenticatesUser
  include LightService::Organizer

  def self.check(user)
    with(user: user).reduce [
    ]
  end
end
