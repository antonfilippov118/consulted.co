module Scopable

  module Call
    extend ActiveSupport::Concern

    included do
      scope :future, -> { where active_to: { :$gte => Time.now } }
      scope :past, -> { where active_to: { :$lte => Time.now } }
      scope :callable, -> { where active_from: { :$lte => Time.now + 30.minutes }, active_to: { :$gte => Time.now } }
      scope :by_pin, -> pin { where pin: pin }
      scope :by, -> user { where seeker: user }
      scope :to, -> user { where expert: user }
      scope :for, -> user { any_of({ seeker: user }, { expert: user }) }
      scope :active, -> { where status: Call::Status::ACTIVE }
      scope :requested, -> { where status: Call::Status::REQUESTED }
      scope :declined, -> { where status: Call::Status::DECLINED }
      scope :cancelled, -> { where status: Call::Status::CANCELLED }
      scope :younger, -> number { where active_from: { :$lte => Time.at(Time.now + number.days) } }
      scope :older, -> number { where active_from: { :$gte => Time.at(Time.now + number.days) } }
    end
  end

end
