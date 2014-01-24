class PossibleTime
  include Mongoid::Document
  belongs_to :user

  field :length, type: Integer, default: 60
  field :weekday, type: Integer, default: 0
  field :week_of_year, type: Integer, default: proc { current_week_number }

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

  def weekday_possible?
    if possible_weekdays[weekday].nil?
      errors.add :weekday, 'is not a possible value'
    end
  end

  def possible_weekdays
    %w{Monday Tuesday Wednesday Thursday Friday Saturday Sunday}
  end

  def current_week_number
    Time.now.strftime('%W').to_i
  end
end
