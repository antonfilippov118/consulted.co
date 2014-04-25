module ExpertsHelper

  def profile_image_url
    @expert.profile_image.url
  end

  def current_company
    @expert.companies.current
  end

  def current_company_name
    current_company.name
  end

  def past_companies
    @expert.companies.delete_if { |c| c == current_company }
  end

  def past_companies?
    @expert.shares_career?
  end

  def summary?
    @expert.shares_summary?
  end

  def company_url
    "https://www.linkedin.com/company/#{current_company.linkedin_id}"
  end

  def career_span(company)
    from = "'#{company.from.to_s[-2..3]}"
    return from if company.current?
    return from if company.from == company.to
    "#{from}-'#{company.to.to_s[-2..3]}"
  end

  def current_position
    current_company.position
  end

  def linkedin_profile?
    return false if @expert.user_linkedin_connection.nil?
    @expert.linkedin?
  end

  def linkedin_profile_url
    @expert.user_linkedin_connection.public_profile_url
  end

  def name
    @expert.name
  end

  def summary
    @expert.summary
  end

  def speaks_language?(language)
    @expert.languages.include? language
  end

  def timezone
    ActiveSupport::TimeZone.new(@user.timezone)
  end

  def no_offers?
    @expert.offers.enabled.length > 0
  end

  def profile_class
    return 'yellow' if @user.can_be_an_expert? && !@user.wants_to_be_an_expert?
    return 'red' unless @user.can_be_an_expert?
    ''
  end

  def required_contacts
    Settings.required_network
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

  def user_expert_page?
    @user == @expert
  end

  def education?
    @expert.educations.any? && @expert.shares_education?
  end

  def educations
    @expert.educations
  end

  def education_span(education)
    return if education.from == 0 && education.to == 0
    return "'#{education.from.to_s[-2..3]}" if education.to == education.from
    return "'#{education.from.to_s[-2..3]}" if education.to == 0
    return "'#{education.to.to_s[-2..3]}" if education.from == 0
    "#{education.from.to.to_s[-2..3]}-'#{education.to.to_s[-2..3]}"
  end

  def bookmarked?(expert)
    @user.favorites.where(favorite_id: expert.id).exists?
  end
end
