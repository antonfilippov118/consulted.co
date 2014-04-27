module Validatable
  module PlatformSettings
    extend ActiveSupport::Concern

    included do
      validates_numericality_of :platform_fee, greater_than_or_equal_to: 1, less_than_or_equal_to: 100
      validates_numericality_of :cancellation_fee, greater_than_or_equal_to: 1, less_than_or_equal_to: 100
      validates_numericality_of :call_dispute_period, greater_than_or_equal_to: 0
      validates_numericality_of :block_time, greater_than: 0
      validates_numericality_of :session_timeout, greater_than_or_equal_to: 0
      validates :email_default_from, email: true
    end
  end
end
