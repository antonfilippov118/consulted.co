class PossibleTimeValidator
  def validate(user)
    true
  end

  class CountValidator
    def validate(user)
      false
    end
  end
end
