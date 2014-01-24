class PossibleTimeValidator
  def validate(user)
    user.confirmed?
  end

  class CountValidator
    def validate(user)
      false
    end
  end
end
