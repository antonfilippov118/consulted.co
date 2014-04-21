module UsersHelper
  def possible_expert?
    @user.can_be_an_expert?
  end

  def needs_more_contacts?
    @user.linkedin_network < User.required_connections
  end

  def needs_confirmation?
    !@user.confirmed?
  end

  def needs_linkedin?
    !@user.linkedin?
  end

  def needs_payment?
    false
  end

  def needs_expert_terms?
    false
  end

  def hours_left
    distance_of_time_in_words(@user.confirmation_sent_at + 48.hours - Time.now)
  end
end
