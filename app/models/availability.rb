class Availability
  include Mongoid::Document
  belongs_to :user

  field :starts, type: DateTime, default: DateTime.now
  field :ends, type: DateTime, default: DateTime.now + 60.minutes
  field :recurring, type: Boolean, default: false
  field :week, type: Integer, default: -> { Date.today.cweek }

  scope :recurring, -> { where recurring: true }
  scope :for, -> (user) { where user: user }
  scope :in_week, -> (week) { where week: week }

  private

  before_save do
    self.week = starts.to_date.cweek
  end
end
