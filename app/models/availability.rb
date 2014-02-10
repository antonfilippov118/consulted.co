class Availability
  include Mongoid::Document
  belongs_to :user

  field :starts, type: Time, default: Time.now
  field :ends, type: Time, default: Time.now + 60.minutes
  field :recurring, type: Boolean, default: false
  field :week, type: Integer, default: -> { starts.strftime('%W').to_i }

  scope :recurring, -> { where recurring: true }
  scope :for, -> (user) { where user: user }
  scope :in_week, -> (week) { where week: week }

  private

  before_save do
    self.week = starts.strftime('%W').to_i
  end
end
