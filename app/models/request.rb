class Request
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :seeker, class_name: 'User', foreign_key: 'seeker_id'
  belongs_to :expert, class_name: 'User', foreign_key: 'expert_id'

  field :language, type: String
  field :length, type: Integer
  field :start, type: DateTime
  field :message, type: String
  field :offer_id
  field :cancelled, type: Boolean, default: false
  field :declined, type: Boolean, default: false
  field :accepted, type: Boolean, default: false

  delegate :group, to: :offer
  delegate :name, to: :offer

  def offer
    expert.offers.find offer_id
  end

  def cancel!
    self.cancelled = true
    save!
  end

  scope :by, -> user { where seeker: user }
  scope :to, -> user { where expert: user }
  scope :active, -> { where cancelled: false, declined: false, accepted: false }
  scope :declined, -> { where declined: true }
  scope :cancelled, -> { where cancelled: true }
  scope :accepted, -> { where accepted: true, cancelled: false, declined: false }
end
