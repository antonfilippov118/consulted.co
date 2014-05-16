module Scopable
  module Availability
    extend ActiveSupport::Concern

    included do
      scope :future, -> { where ending: { :$gte => Time.now } }
      scope :with_date, -> dates { where date: { :$in => dates } }
      scope :next_days, -> days { where ending: { :$lte => days.days.from_now } }
      scope :within, -> starting, ending { where starting: { :$lte => starting }, ending: { :$gte => ending } }
      scope :for, -> user_ids { where user: { :$in => user_ids } }
    end
  end
end
