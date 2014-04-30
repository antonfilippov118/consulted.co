class FindsOffers
  include LightService::Organizer

  def self.for(params, user = nil)
    with(params: params, user: user).reduce [
      FindGroup,
      FindExperts,
      FilterExpertsByLanguages,
      FilterExpertsByContinents,
      FindOffers,
      FilterOffersByRate,
      FilterOffersByExperience
      # ExcludeSelf
    ]
  end

  class FindGroup
    include LightService::Action

    executed do |context|
      begin
        params = context.fetch :params
        id     = params.fetch :group
        context[:group] = Group.find id
      rescue => e
        context.fail! e.message
      end
    end
  end

  class FindExperts
    include LightService::Action
    executed do |context|
      experts = User.experts
      context[:experts] = experts
    end
  end

  class FilterExpertsByLanguages
    include LightService::Action

    executed do |context|
      params    = context.fetch :params
      next context if params[:languages].nil?
      experts   = context.fetch :experts
      languages = params.fetch :languages
      context[:experts] = experts.with_languages languages
    end
  end

  class FilterExpertsByContinents
    include LightService::Action

    executed do |context|
      params     = context.fetch :params
      next context if params[:continents].nil?
      experts    = context.fetch :experts
      continents = params.fetch :continents
      context[:experts] = experts.with_continent continents
    end
  end

  class FindOffers
    include LightService::Action

    executed do |context|
      experts = context.fetch :experts
      group   = context.fetch :group
      context[:offers] = Offer.with_group(group).valid.any_in user: experts.map(&:id)
    end
  end

  class FilterOffersByExperience
    include LightService::Action
    executed do |context|
      params = context.fetch :params
      if params[:experience_upper].nil? || params[:experience_lower].nil?
        next context
      end
      offers = context.fetch :offers
      upper = params.fetch :experience_upper
      lower = params.fetch :experience_lower
      context[:offers] = offers.with_experience lower, upper
    end
  end

  class FilterOffersByRate
    include LightService::Action
    executed do |context|
      params = context.fetch :params
      if params[:rate_upper].nil? || params[:rate_lower].nil?
        next context
      end
      offers = context.fetch :offers
      upper = params.fetch :rate_upper
      lower = params.fetch :rate_lower
      context[:offers] = offers.with_rate lower, upper
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
