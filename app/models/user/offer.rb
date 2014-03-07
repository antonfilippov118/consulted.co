class User::Offer
  include Mongoid::Document
  belongs_to :group
  embedded_in :user

  field :description, type: String
  field :experience, type: Integer
  field :rate, type: Integer, default: 0
  field :lengths, type: Array, default: []
  field :enabled, type: Boolean, default: true

  delegate :languages, to: :user
  delegate :availabilities, to: :user
  delegate :name, to: :group

  scope :with_length, -> length { where lengths: length }
  scope :with_group, -> group { where group: group }
  scope :valid, -> { where :description.ne => '', enabled: true, :rate.gt => 0, :experience.gt => 0, :lengths.ne => []  }
  scope :enabled, -> { where enabled: true }
end
