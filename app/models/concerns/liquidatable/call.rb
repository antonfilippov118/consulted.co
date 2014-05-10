module Liquidatable
  module Call
    extend ActiveSupport::Concern

    def to_liquid
      {
        'time' => 'now',
        'message' => message,
        'seeker' => seeker,
        'expert' => expert,
        'duration' => length,
        'languages' => expert.languages.map(&:capitalize).join(', ')
      }
    end
  end
end
