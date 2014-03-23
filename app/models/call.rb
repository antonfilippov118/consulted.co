class Call
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :expert, class_name: 'User'
  belongs_to :seeker, class_name: 'User'

  field :pin, type: Integer, default: -> { Call.generate_unique_pin }
  field :active_from, type: DateTime
  field :active_to, type: DateTime

  scope :active, -> { where active_from: { :$lte => Time.now }, active_to: { :$gte => Time.now } }
  scope :by_pin, -> pin { where pin: pin }

  private

  def self.generate_unique_pin
    SecureRandom.random_number(999_999)
  end
end
