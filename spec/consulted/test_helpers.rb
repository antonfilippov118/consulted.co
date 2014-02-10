module Consulted
  module TestHelpers

    def valid_params
      {
        email: 'florian@consulted.co',
        name: 'Florian',
        password: 'tester',
        password_confirmation: 'tester',
        confirmation_sent_at: Time.now
      }
    end
  end
end
