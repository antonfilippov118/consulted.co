class PossibleTime
  include Mongoid::Document
  belongs_to :user

  field :length, type: Integer
  field :weekday

  validate :length_possible?
  validate :weekday_possible?
  validates_presence_of :user_id

  private

  def lengths_possible
    [30, 45, 60, 90, 120]
  end

  def length_possible?
    unless lengths_possible.include? length
      errors.add :length, 'is not a possible value'
    end
  end

  def possible_weekdays
    %w{Monday Tuesday Wednesday Thursday Friday Saturday Sunday}
  end
end
