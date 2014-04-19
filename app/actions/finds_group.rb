class FindsGroup
  include LightService::Organizer

  def self.for(text)
    with(text: text).reduce [
      FindByName,
      FindByDescription,
      MergeResults
    ]
  end

  class FindByName
    include LightService::Action

    executed do |context|
      text = context.fetch :text
      regexp = Regexp.new ".*#{text}.*", 'i'
      context[:by_name] = Group.leaves.any_of(name: regexp).to_a
    end
  end

  class FindByDescription
    include LightService::Action
    executed do |context|
      text = context.fetch :text
      regexp = Regexp.new ".*#{text}.*", 'i'
      context[:by_description] = Group.leaves.any_of(description: regexp).to_a
    end
  end

  class MergeResults
    include LightService::Action

    executed do |context|
      by_name, by_description = context.values_at :by_name, :by_description
      context[:groups] = (by_name + by_description).uniq
    end
  end
end
