class PossibleTime
  include Mongoid::Document
  belongs_to :user

  field :length, type: Integer

  validate :period_possible?

  private

  def possible_periods
    [30, 45, 60, 90, 120]
  end

  def period_possible?
    unless possible_periods.include? length
      errors.add :time, 'is not a possible value'
    end
  end
end
