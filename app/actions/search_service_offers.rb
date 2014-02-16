
class SearchServiceOffers
  include LightService::Organizer
  def self.with_options(options = {})
    with(options).reduce [
      ValidateTimes,
      ValidateLength,
      ValidateLanguage,
      ValidateGroups
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
end
