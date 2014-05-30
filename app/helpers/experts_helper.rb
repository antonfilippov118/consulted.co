module ExpertsHelper

  def profile_image_url
    @expert.profile_image.url
  end

  def current_company
    @expert.companies.current
  end

  def current_company_name
    return '' if current_company.nil?
    current_company.name
  end

  def current_company_city
    return '' if current_company.nil?
    current_company.city
  end

  def past_companies
    @expert.past_companies
  end

  def past_companies?
    @expert.shares_career? && @expert.companies.any?
  end

  def summary?
    @expert.shares_summary? && @expert.summary.present?
  end

  def company_url
    return false if current_company.nil?
    current_company.url
  end

  def career_span(company)
    from = "'#{company.from.to_s[-2..3]}"
    return from if company.current?
    return from if company.from == company.to
    "#{from}-'#{company.to.to_s[-2..3]}"
  end

  def current_position
    return false if current_company.nil?
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

  def expert_timezone
    ActiveSupport::TimeZone.new(@expert.timezone)
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

  def expert_page(expert = nil)
    if expert.nil?
      expert = @expert
    end
    "#{root_url}#{expert.slug}"
  end

  def user_expert_page?
    @user == @expert
  end

  def expert_languages
    @expert.languages.map(&:capitalize).join ', '
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
    return false unless @user
    @user.favorites.where(favorite_id: expert.id).exists?
  end

  def expert_twitter?
    @expert.twitter_handle.present?
  end

  def expert_twitter_url
    return '' unless expert_twitter?
    url = @expert.twitter_handle.gsub '@', ''
    "https://twitter.com/#{url}"
  end
end
