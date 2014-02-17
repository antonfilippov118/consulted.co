
class SearchServiceOffers
  include LightService::Organizer
  def self.with_options(options = {})
    with(options).reduce [
      ValidateTimes,
      ValidateLength,
      ValidateLanguage,
      ValidateGroups,
      FindUsersWithLanguages,
      MatchOffers,
      ReduceOffersByAvailability
    ]
  end

  class ValidateTimes
    include LightService::Action
    executed do |context|
      times = context.fetch :times

      if times.empty?
        context.set_failure! 'No times given!'
      end
    end
  end

  class ValidateLength
    include LightService::Action
    executed do |context|
      begin
        context.fetch :length
      rescue KeyError
        context.set_failure! 'No length given!'
      end
    end
  end

  class ValidateLanguage
    include LightService::Action
    executed do |context|
      languages = context.fetch :languages
      if languages.empty?
        context.set_failure! 'No languages given!'
      end
    end
  end

  class ValidateGroups
    include LightService::Action
    executed do |context|
      groups = context.fetch :groups

      begin
        Group.find groups
      rescue => e
        context.set_failure! 'Group not found!'
        context[:error] = e
      end
    end
  end

  class FindUsersWithLanguages
    include LightService::Action
    executed do |context|
      begin
        lang = context.fetch :languages
        context[:experts] = User.confirmed.experts.with_languages lang
      rescue => e
        context.set_failure! e
      end
    end
  end

  class MatchOffers
    include LightService::Action

    executed do |context|
      experts = context.fetch :experts
      groups  = context.fetch :groups
      length  = context.fetch :length

      context[:possible_offers] = Offer.for(experts.to_a).with_group(groups).with_length length
    end
  end

  class ReduceOffersByAvailability
    include LightService::Action
    executed do |context|
      offers = context.fetch :possible_offers
      times  = context.fetch :times

      offers = offers.reject { |offer| !offer.available_for(times) }

      context[:offers] = offers
      context[:users]  = offers.map(&:user)
    end
  end
end
