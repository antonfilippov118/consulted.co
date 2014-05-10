module Liquidatable
  module Call
    extend ActiveSupport::Concern

    def to_liquid
      {
        'time' => 'now'
      }
    end
  end
end
