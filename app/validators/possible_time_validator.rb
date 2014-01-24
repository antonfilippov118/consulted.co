class PossibleTimeValidator < ActiveModel::Validator
  def validate(time)
    ExpertValidator.validate time
    CountValidator.validate time
  end

  class ExpertValidator
    def self.validate(time)

      if time.user.nil?
        return false
      end

      if time.user && !time.user.confirmed?
        time.errors.add :base, 'User must be confirmed!'
        return false
      end

      if time.user && !time.user.can_be_an_expert?
        time.errors.add :base, 'User must be an expert to save times!'
        return false
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
