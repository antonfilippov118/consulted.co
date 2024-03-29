module UsersHelper
  def possible_expert?
    user.can_be_an_expert?
  end

  def needs_more_contacts?
    user.linkedin_network < User.required_connections
  end

  def needs_confirmation?
    !user.confirmed?
  end

  def needs_linkedin?
    !user.linkedin?
  end

  def needs_payment?
    false
  end

  def needs_expert_terms?
    false
  end

  def twitter?
    return false unless @user
    @user.twitter_handle.present?
  end

  def hours_left
    distance_of_time_in_words(user.confirmation_sent_at + 48.hours - Time.now)
  end

  def active_profile?
    user.can_be_an_expert? && user.wants_to_be_an_expert?
  end

  def own_profile_image_url
    user.profile_image.url
  end

  def own_current_company
    user.companies.current
  end

  def own_current_company_name
    own_current_company.name
  end

  def own_past_companies
    user.companies.select { |c| c != own_current_company }.compact
  end

  def timezone
    ActiveSupport::TimeZone.new(user.timezone)
  end

  def current_tz_offset
    timezone.now.formatted_offset
  end

  def own_company_url
    return false if own_current_company.nil?
    return false if own_current_company.linkedin_id.nil?
    "https://www.linkedin.com/company/#{own_current_company.linkedin_id}"
  end

  def own_career_span(company)
    from = "'#{company.from.to_s[-2..3]}"
    return from if company.current?
    return from if company.from == company.to
    "#{from}-'#{company.to.to_s[-2..3]}"
  end

  def own_current_position
    own_current_company.position
  end

  def own_summary
    user.summary
  end

  def summary_shared?
    user.shares_summary?
  end

  def career_shared?
    user.shares_career?
  end

  def education_shared?
    user.shares_education?
  end

  def own_educations
    user.educations
  end

  def user
    @user || User.new
  end

  def break_settings
    [
      ['No break', 0],
      ['15 minutes', 15],
      ['30 Minutes', 30],
      ['45 Minutes', 45],
      ['1 Hour', 60]
    ]
  end

  def delays
    [
      ['30 minutes', 30],
      ['1 hour', 60],
      ['4 hours', 240],
      ['1 day', 1440],
      ['2 days', 2880],
      ['3 days', 4320],
      ['1 week', 10_080]
    ]
  end
end
