class PossibleTimeValidator
  def validate(user)
    user.confirmed?
  end

  class CountValidator
    def validate(user)
      false
    end

    #TODO: make this configurable
    def maximum
      10
    end
  end
end
