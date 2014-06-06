class Call
  include Mongoid::Document
  include Mongoid::Timestamps
  include Liquidatable::Call
  include Scopable::Call
  include Changeable::Call
  include Pricable::Call
  include Tokenable::Call
  include Reviewable::Call

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

  belongs_to :invoice, dependent: :destroy

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
  field :languages, type: Array, default: []

  index pin: 1, status: 1

  delegate :name, to: :offer
  delegate :group, to: :offer

  alias_method :topic, :name

  def create_invoice
    inv = Invoice.create!
    begin
      inv.call = self # saves relation in call.invoice_id
      inv.create_pdf
    rescue
      inv.call = nil # removes relation from call.invoice_id
      inv.destroy
      raise
    end
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
    length + expert.break
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
    return if availability.nil?
    availability = expert.availabilities.within(active_from.utc, active_to.utc).first
    availability.free!(active_from.utc, length)
  end

end
