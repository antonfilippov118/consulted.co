module Liquidatable
  module User
    extend ActiveSupport::Concern

    def to_liquid
      {
        'name'       => name,
        'first_name' => first_name,
        'last_name'  => last_name,
        'email'      => email
      }
    end
  end
end
