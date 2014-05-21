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
  field :expert_reminder_sent, type: Boolean, default: false
  field :seeker_reminder_sent, type: Boolean, default: false
  field :expert_reminder_sent_at, type: DateTime
  field :seeker_reminder_sent_at, type: DateTime
  field :rating_reminder_sent, type: Boolean, default: false
  field :rating_reminder_sent_at, type: DateTime
  field :rate, type: Integer

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
    rate / 100
  end

  private

  before_save :ending!
  before_save :calc_rate!
  after_save :book!
  after_destroy :free!

  def self.generate_unique_pin
    # TODO: this can potentially collide with other active calls
    SecureRandom.random_number(999_999)
  end

  def ending!
    self.active_to = active_from + length.minutes
  end

  def book!
    availability = expert.availabilities.within(active_from.utc, active_to.utc).first
    if active?
      availability.book! active_from.utc, length
    end
    if cancelled?
      availability.free! active_from.utc, length
    end
  end

  def free!
    availability = expert.availabilities.within(active_from.utc, active_to.utc).first
    availability.free!(active_from.utc, length)
  end

  def calc_rate!
    return if offer.nil?
    self.rate = (offer.rate * length / 60) * 100
  end
end
