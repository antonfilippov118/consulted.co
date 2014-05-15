class Call
  include Mongoid::Document
  include Mongoid::Timestamps
  include Liquidatable::Call
  include Scopable::Call

  class Status
    REQUESTED = 1
    DECLINED  = 2
    ACTIVE    = 3
    CANCELLED = 4
    COMPLETED = 5
    DISPUTED  = 6
  end

  belongs_to :expert, class_name: 'User', foreign_key: 'expert_id', inverse_of: :experts
  belongs_to :seeker, class_name: 'User', foreign_key: 'seeker_id', inverse_of: :requests
  belongs_to :offer

  field :pin, type: Integer, default: -> { Call.generate_unique_pin }
  field :length, type: Integer
  field :active_from, type: DateTime
  field :active_to, type: DateTime
  field :status, type: Integer, default: Call::Status::REQUESTED
  field :message, type: String

  field :confirmed_at, type: DateTime
  field :cancelled_at, type: DateTime

  index pin: 1

  delegate :name, to: :offer
  delegate :group, to: :offer

  alias_method :topic, :name

  def confirm!
    self.status = Call::Status::ACTIVE
    save
  end

  def active?
    status == Call::Status::ACTIVE
  end

  private

  before_save :ending!
  after_save :book!

  def self.generate_unique_pin
    SecureRandom.random_number(999_999)
  end

  def ending!
    self.active_to = active_from + length.minutes
  end

  def book!
    if active?
      availability = expert.availabilities.within(active_from.utc, active_to.utc).first
      availability.book! active_from.utc, length
    end
  end
end
