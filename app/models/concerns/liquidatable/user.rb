module Liquidatable
  module User
    extend ActiveSupport::Concern

    def to_liquid
      {
        'name' => name,
        'email' => email
      }
    end
  end
end
