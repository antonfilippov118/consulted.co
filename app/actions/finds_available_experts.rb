class FindsAvailableExperts
  include LightService::Organizer

  def self.for(params, user = nil)
    with(params: params, user: user).reduce [
      FindGroup,
      FindExperts,
      FilterExpertsByRate,
      FilterExpertsByExperience,
      FilterExpertsByDateTime,
      ExcludeSelf
    ]
  end

  class FindGroup
    include LightService::Action

    executed do |context|
      begin
        params = context.fetch :params
        id     = params.fetch :group_id
        context[:group] = Group.find id
      rescue => e
        context.fail! e.message
      end
    end
  end

  class FindExperts
    include LightService::Action
    executed do |context|
      group   = context.fetch :group
      experts = User.experts.with_group group
      context[:experts] = experts
    end
  end

  class FilterExpertsByRate
    include LightService::Action

    executed do |context|
      params = context.fetch :params
      upper  = params[:rate_upper]
      lower  = params[:rate_lower]

      upper = 10_000 if upper == ''
      lower = 0 if lower == ''

      if upper && lower
        experts = context.fetch :experts
        context[:experts] = experts.rates_between lower.to_i, upper.to_i
      end
    end
  end

  class FilterExpertsByExperience
    include LightService::Action

    executed do |context|
      params = context.fetch :params
      upper  = params[:experience_upper]
      lower  = params[:experience_lower]

      upper  = 100 if upper == ''
      lower  = 0 if lower == ''

      if upper && lower
        experts = context.fetch :experts
        context[:experts] = experts.experiences_between lower.to_i, upper.to_i
      end
    end
  end

  class FilterExpertsByDateTime
    include LightService::Action

    executed do |context|
      experts = context.fetch :experts
      next context if experts.length == 0

      params = context.fetch :params
      date   = params[:date]
      time   = params[:time]
      time   = nil if time == 'on'
      date   = nil if date == 'on'

      next context if time.nil? && date.nil?

      if date && time
        from, to = time.split('_')

        from    = Time.zone.parse "#{date} #{from}:00"
        experts = experts.available_from from
        unless to.nil?
          to = Time.zone.parse "#{date} #{to}:00"
          experts = experts.available_to to
        end
      end

      if date.nil? && time
        from, to = time.split('_').map(&:to_i)

        experts = experts.with_hours_from from

        unless to.nil?
          experts = experts.with_hours_to to
        end
      end

      if date && time.nil?
        _date = Time.zone.parse date

        experts_specific_day = experts.available_on(_date)
        experts_recurring    = experts.on_day Date.parse(date).cwday
        experts              = experts_specific_day.concat experts_recurring
      end
      context[:experts] = experts
    end
  end

  class ExcludeSelf
    include LightService::Action

    executed do |context|
      user = context.fetch :user
      next context if user.nil?
      experts = context.fetch :experts

      experts = experts.where id: { :$ne => user.id }
      context[:experts] = experts
    end
  end
end
