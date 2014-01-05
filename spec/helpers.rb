# Helpers for the specs
module Helpers
  def create_user(opts = {})
    params = {
      email: 'Florian@consulted.co',
      password: 'tester',
      password_confirmation: 'tester',
      name: 'Florian',
      confirmed: true,
      active: true
    }.merge opts

    user_class.create params
  end

  def user_class
    User
  end
end
