class Call
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :expert, class_name: 'User', inverse_of: :meetings, foreign_key: 'expert_id'
  belongs_to :seeker, class_name: 'User', inverse_of: :calls, foreign_key: 'seeker_id'

  field :pin, type: Integer, default: -> { Call.generate_unique_pin }
  field :active_from, type: DateTime
  field :active_to, type: DateTime
  field :topic, type: String

  scope :active, -> { where active_from: { :$lte => Time.now }, active_to: { :$gte => Time.now } }
  scope :future, -> { where active_from: { :$gte => Time.now } }
  scope :by_pin, -> pin { where pin: pin }

  def active?
    active_from <= Time.now && Time.now <= active_to
  end

  private

  def self.generate_unique_pin
    SecureRandom.random_number(999_999)
  end
end
