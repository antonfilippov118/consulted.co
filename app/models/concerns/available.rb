module Available
  extend ActiveSupport::Concern

  included do
    def next_possible_call
      time = availabilities.map(&:next_possible_time).reject { |value| !!value == false }.min

      return false if time.nil?
      Time.at time
    end
  end
end
