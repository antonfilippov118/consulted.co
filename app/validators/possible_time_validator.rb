class PossibleTimeValidator
  def validate(user)
    user.confirmed?
  end

  class CountValidator
    def validate(user)
      if user.possible_times.count > maximum_per_week
        return false
      else
        return true
      end
    end

    # TODO: make this configurable
    def maximum_per_week
      10
    end
  end
end
