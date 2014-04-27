class Request
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :seeker, class_name: 'User', foreign_key: 'seeker_id'
  belongs_to :expert, class_name: 'User', foreign_key: 'expert_id'
  belongs_to :offer

  field :length, type: Integer
  field :message, type: String
  field :cancelled, type: Boolean, default: false
  field :declined, type: Boolean, default: false
  field :accepted, type: Boolean, default: false

  delegate :group, to: :offer
  delegate :name, to: :offer

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

  def to_liquid
    { name: name }
  end
end
