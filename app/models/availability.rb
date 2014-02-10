class Availability
  include Mongoid::Document
  belongs_to :user

  field :starts, type: Time, default: Time.now
  field :ends, type: Time, default: Time.now + 60.minutes
  field :recurring, type: Boolean, default: false

  scope :recurring, -> { where recurring: true }
  scope :for_user, -> (user) { where user: user }

end
