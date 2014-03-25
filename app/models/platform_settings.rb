class PlatformSettings
  include Mongoid::Document
  include Validatable::PlatformSettings

  field :platform_fee, type: Integer, default: 1
  field :cancellation_fee, type: Integer, default: 1
  field :call_dispute_period, type: Integer, default: 0
  field :block_time, type: Integer, default: 1
  field :session_timeout, type: Integer, default: 0

  before_validation :ensure_has_only_one_record, on: :create

  private

  def ensure_has_only_one_record
    if self.class.count > 0
      errors.add :base, "There can only be one record of #{self.class}"
    end
  end
end
