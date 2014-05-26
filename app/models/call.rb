class Call
  include Mongoid::Document
  include Mongoid::Timestamps
  include Liquidatable::Call
  include Scopable::Call
  include Pricable::Call

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
  belongs_to :availability

  field :pin, type: Integer, default: -> { Call.generate_unique_pin }
  field :length, type: Integer
  field :active_from, type: DateTime
  field :active_to, type: DateTime
  field :status, type: Integer, default: Call::Status::REQUESTED
  field :message, type: String
  field :expert_reminder_sent, type: Boolean, default: false
  field :seeker_reminder_sent, type: Boolean, default: false
  field :expert_reminder_sent_at, type: DateTime
  field :seeker_reminder_sent_at, type: DateTime
  field :rating_reminder_sent, type: Boolean, default: false
  field :rating_reminder_sent_at, type: DateTime
  field :confirmed_at, type: DateTime
  field :cancelled_at, type: DateTime

  index pin: 1, status: 1

  delegate :name, to: :offer
  delegate :group, to: :offer

  alias_method :topic, :name

  def confirm!
    self.status = Call::Status::ACTIVE
    save!
  end

  def decline!
    self.status = Call::Status::DECLINED
    save!
  end

  def cancel!
    self.status = Call::Status::CANCELLED
    save!
  end

  def complete!
    self.status = Call::Status::COMPLETED
    save
  end

  def active?
    status == Call::Status::ACTIVE
  end

  def cancelled?
    status == Call::Status::CANCELLED
  end

  def declined?
    status == Call::Status::DECLINED
  end

  def complete?
    status == Call::Status::COMPLETED
  end

  def cancellable?
    active_from > Time.now
  end

  def payment
    (rate.to_f / 100)
  end

  private

  before_save :ending!, :availability!, :check_pin!
  after_save :book!
  after_destroy :free!

  def length_with_break
    length + expert.start_delay
  end

  def self.generate_unique_pin
    100_000 + Random.rand(1_000_000 - 100_000)
  end

  def ending!
    self.active_to = active_from + length.minutes
  end

  def availability!
    self.availability = expert.availabilities.within(active_from.utc, active_to.utc).first
  end

  def check_pin!
    self.pin = Call.generate_unique_pin while Call.callable.by_pin(pin).exists?
  end

  def book!
    return if availability.nil?
    if cancelled? || declined?
      availability.free! active_from.utc, length_with_break
    else
      availability.book! active_from.utc, length_with_break
    end
  end

  def free!
    availability = expert.availabilities.within(active_from.utc, active_to.utc).first
    availability.free!(active_from.utc, length)
  end

end
