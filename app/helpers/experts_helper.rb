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

  def no_offers?
    @user.offers.enabled.length > 0
  end

  def possible_times
    [['Back to Back', 0], ['15 Minutes', 15], ['30 Minutes', 30], ['45 Minutes']]
  end

  def possible_starts
    [['No delay neccessary', 0], ['15 Minutes before', 15], ['30 Minutes before', 30], ['45 Minutes before']]
  end

  def possible_meetings
    empty  = [['Until filled up', 0]]
    filled = (1..12).map { |number| ["#{number} meeting#{number == 1 ? '' : 's'}", number] }
    empty + filled
  end
end
