module Available
  extend ActiveSupport::Concern

  included do
    def next_possible_call(offer = nil)
      time = availabilities.future.map { |a| a.next_possible_time offer }.reject { |value| !!value == false }.min

      return false if time.nil?
      Time.at time
    end

    def maximum_call_length(offer)
      time = availabilities.future.map { |a| a.maximum_call_length(offer) }.reject { |value| value == 0 }.max
      return false if time.nil?
      time
    end
  end
end
