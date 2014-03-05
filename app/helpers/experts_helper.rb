module ExpertsHelper
  def needs_more_contacts?
    @user.linkedin_network < User.required_connections
  end

  def needs_confirmation?
    !@user.confirmed?
  end

  def needs_linkedin?
    !@user.linkedin?
  end
end
