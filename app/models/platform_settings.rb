class PlatformSettings
  include Mongoid::Document
  include Validatable::PlatformSettings

  field :platform_fee, type: Integer, default: 15
  field :cancellation_fee, type: Integer, default: 50
  field :cancellation_period, type: Integer, default: 12
  field :call_dispute_period, type: Integer, default: 0
  field :block_time, type: Integer, default: 10
  field :session_timeout, type: Integer, default: 0
  field :required_network, type: Integer, default: 10
  field :platform_live, type: Boolean, default: false

  before_validation :ensure_has_only_one_record, on: :create

  def continents
    regions = Country.all.map { |country| Country.new(country.last).continent }
    regions.uniq
  end

  private

  def ensure_has_only_one_record
    if self.class.count > 0
      errors.add :base, "There can only be one record of #{self.class}"
    end
  end
end
