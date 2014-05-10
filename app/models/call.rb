class Call
  include Mongoid::Document
  include Mongoid::Timestamps
  include Liquidatable::Call

  class Status
    REQUESTED = 1
    ACTIVE    = 2
    CANCELLED = 3
  end

  belongs_to :expert, class_name: 'User', foreign_key: 'expert_id', inverse_of: :experts
  belongs_to :seeker, class_name: 'User', foreign_key: 'seeker_id', inverse_of: :requests
  belongs_to :offer

  field :pin, type: Integer, default: -> { Call.generate_unique_pin }
  field :active_from, type: DateTime
  field :active_to, type: DateTime
  field :length, type: Integer
  field :status, type: Integer, default: Call::Status::REQUESTED

  field :confirmed_at, type: DateTime
  field :cancelled_at, type: DateTime

  index pin: 1

  delegate :name, to: :offer
  delegate :group, to: :offer

  alias_method :topic, :name
  attr_accessor :message

  def active?
    active_from <= Time.now && Time.now <= active_to
  end

  # scope :active, -> { where active_from: { :$lte => Time.now }, active_to: { :$gte => Time.now } }
  scope :future, -> { where active_from: { :$gte => Time.now } }
  scope :past, -> { where active_to: { :$lte => Time.now } }
  scope :by_pin, -> pin { where pin: pin }
  scope :by, -> user { where seeker: user }
  scope :to, -> user { where expert: user }
  scope :for, -> user { any_of({ seeker: user }, { expert: user }) }
  scope :active, -> { where status: Call::Status::ACTIVE }
  scope :requested, -> { where status: Call::Status::REQUESTED }
  scope :declined, -> { where status: Call::Status::DECLINED }
  scope :cancelled, -> { where status: Call::Status::CANCELLED }

  private

  def self.generate_unique_pin
    SecureRandom.random_number(999_999)
  end
end
