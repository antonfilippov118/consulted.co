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

  def needs_payment?
    false
  end

  def needs_expert_terms?
    false
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

  def timezone
    ActiveSupport::TimeZone.new(@user.timezone)
  end

  def no_offers?
    @user.offers.enabled.length > 0
  end

  def active_profile?
    @user.can_be_an_expert? && @user.wants_to_be_an_expert?
  end

  def profile_class
    return 'yellow' if @user.can_be_an_expert? && !@user.wants_to_be_an_expert?
    return 'red' unless @user.can_be_an_expert?
    ''
  end

  def required_contacts
    Settings.required_network
  end

  def hours_left
    distance_of_time_in_words(@user.confirmation_sent_at + 48.hours - Time.now)
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

  def offer_for(opts = {})
    defaults = {
      expert: User.new,
      group: @group
    }
    opts   = defaults.merge opts
    expert = opts.fetch :expert
    group  = opts.fetch :group
    expert.offers.with_group(group).first || User::Offer.new
  end

  def expert_page(expert)
    "#{root_url}#{expert.slug}"
  end
end
