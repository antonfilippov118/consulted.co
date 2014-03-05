module ExpertsHelper
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

  def profile_image_url
    @user.profile_image.remote_url
  end

  def current_company
    @user.current_company.name
  end

  def current_position
    @user.current_position
  end

  def name
    @user.name
  end

  def summary
    @user.summary
  end

  def previous_companies
    @user.companies.drop 1
  end

  def previous_companies?
    previous_companies.any?
  end

  def speaks_language?(language)
    @user.languages.include? language
  end
end
