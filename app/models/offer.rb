class Offer
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :user
  belongs_to :group

  field :description, type: String
  field :experience, type: Integer
  field :rate, type: Integer, default: 0
  field :lengths, type: Array, default: []
  field :enabled, type: Boolean, default: true

  validate :lengths_possible?

  delegate :languages, to: :user
  delegate :availabilities, to: :user
  delegate :name, to: :group

  scope :for, -> experts { where user_id: { :$in => experts } }
  scope :with_group, -> groups { where group_id: { :$in => groups } }
  scope :with_length, -> length { where lengths: length }

  def available?
    availabilities.length > 0
  end

  def unavailable?
    availabilities.length == 0
  end

  def available_for(times = [])
    return false if times.empty?
    available = false
    times.each do |time|
      available = availabilities.covering(time[:starts], time[:ends]).exists?
    end
    available
  end

  def _group_id
    group_id.to_s
  end

  private

  def allowed_lengths
    %W(30 45 60 90 120)
  end

  def lengths_possible?
    return true if lengths.nil?

    lengths.each do |length|
      unless allowed_lengths.include? length
        errors.add :lengths, 'has an unallowed value!'
        return false
      end
    end
  end
end
