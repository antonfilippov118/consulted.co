class Call
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :expert, class_name: 'User'
  belongs_to :seeker, class_name: 'User'

  field :pin, type: Integer, default: -> { Call.generate_unique_pin }
  field :active_from, type: DateTime
  field :active_to, type: DateTime

  index({ pin: 1 }, unique: true)

  private

  def self.generate_unique_pin
    SecureRandom.random_number(10_000_000)
  end
end
