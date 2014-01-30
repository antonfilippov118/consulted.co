class Offer
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :user
  belongs_to :group

  field :description, type: String
  field :experience, type: Integer
  field :rate, type: Integer, default: 0
  field :lengths, type: Array, default: [30]

  [:experience, :description, :user_id, :group_id, :rate].each do |value|
    validates_presence_of value
  end

  [:experience, :rate].each do |value|
    validates_numericality_of value
  end

  validate :lengths_possible?

  delegate :languages, to: :user
  delegate :availabilities, to: :user

  def available?
    availabilities.length > 0
  end

  def unavailable?
    availabilities.length == 0
  end

  private

  def allowed_lengths
    [30, 45, 60, 90, 120]
  end

  def lengths_possible?
    lengths.each do |length|
      unless allowed_lengths.include? length
        errors.add :lengths, 'has an unallowed value!'
      end
    end
  end
end
