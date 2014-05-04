class Offer
  include Mongoid::Document
  include Sluggable::Offer
  belongs_to :group
  belongs_to :user, dependent: :destroy

  field :description, type: String
  field :experience, type: Integer, default: 1
  field :rate, type: Integer, default: 0
  field :lengths, type: Array, default: []
  field :enabled, type: Boolean, default: true

  delegate :languages, to: :user
  delegate :availabilities, to: :user
  delegate :name, to: :group
  delegate :slug, to: :group

  scope :with_length, -> length { where lengths: length }
  scope :with_group, -> group { where group: group }
  scope :valid, -> { where enabled: true, :rate.gt => 0, :experience.gt => 0, :lengths.ne => []  }
  scope :enabled, -> { where enabled: true }
  scope :with_experience, -> lower, upper { where experience: { :$lte => upper, :$gte => lower } }
  scope :with_rate, -> lower, upper { where rate: { :$lte => upper, :$gte => lower } }

  alias_method :expert, :user
end
