module Available
  extend ActiveSupport::Concern

  included do
    def next_possible_call(offer = nil, dates = [])
      time = next_times(offer, dates).min
      return false if time.nil?
      Time.at time
    end

    def next_times(offer = nil, dates = [])

      avail(dates).future.map { |a| a.next_possible_time offer }.reject { |value| !!value == false }
    end

    def maximum_call_length(offer, dates = [])
      time = avail(dates).future.map { |a| a.maximum_call_length(offer) }.reject { |value| value == 0 }.max
      return false if time.nil?
      time
    end

    def avail(dates = [])
      if dates.any?
        availabilities.with_date dates
      else
        availabilities
      end
    end
  end
end
