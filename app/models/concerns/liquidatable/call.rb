module Liquidatable
  module Call
    extend ActiveSupport::Concern

    def to_liquid
      {
        'time' => 'now',
        'message' => message,
        'seeker' => seeker,
        'expert' => expert
      }
    end
  end
end
