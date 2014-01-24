class PossibleTimeValidator < ActiveModel::Validator
  def validate(time)
    ExpertValidator.validate time
    CountValidator.validate time
  end

  class ExpertValidator
    def self.validate(time)
      if time.user && !time.user.confirmed?
        time.errors.add :base, 'User must be confirmed!'
        false
      end
      true
    end
  end

  class CountValidator
    def self.validate(time)
      true
    end

    # TODO: make this configurable
    def maximum_per_week
      10
    end

    def maximum_minutes_per_day
      1440
    end
  end
end
