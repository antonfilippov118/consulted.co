class PossibleTimeValidator < ActiveModel::Validator
  def validate(time)
    return false if time.user.nil?
    ExpertValidator.validate time
    CountValidator.validate time
  end

  class ExpertValidator
    def self.validate(time)
      return false unless user_confirmed? time
      return false unless user_expert? time
      true
    end

    private

    def self.user_confirmed?(time)
      if time.user && !time.user.confirmed?
        time.errors.add :base, 'User must be confirmed!'
        return false
      end
      true
    end

    def self.user_expert?(time)
      if time.user && !time.user.can_be_an_expert?
        time.errors.add :base, 'User must be an expert to save times!'
        return false
      end
      true
    end
  end

  class CountValidator
    def self.validate(time)
      return false if too_many?
      return false if too_many_a_day? time
      true
    end

    private

    def self.too_many?
      false
    end

    def self.too_many_a_day?(time)
      minutes_today     = PossibleTime.for_user(time.user).on(time.weekday).in_week(time.week_of_year).sum(&:length)
      minutes_recurring = PossibleTime.recurring.for_user(time.user).on(time.weekday).sum(&:length)
      minutes_total     = minutes_recurring + minutes_today + time.length
      if  minutes_total > maximum_minutes_per_day
        time.errors.add :base, "This time cannot be created (#{minutes_total})"
        return true
      end
      false
    end

    # TODO: make this configurable
    def self.maximum_per_week
      30
    end

    def self.maximum_minutes_per_day
      1440
    end

  end
end
