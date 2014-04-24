class FindsGroup
  include LightService::Organizer

  def self.for(text)
    with(text: text).reduce [
      FindByName,
      FindByDescription,
      FindByTag,
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

  class FindByTag
    include LightService::Action

    executed do |context|
      text = context.fetch :text
      context[:by_tag] = Group.leaves.with_tag(text).to_a
    end
  end

  class MergeResults
    include LightService::Action

    executed do |context|
      by_name, by_description, by_tag = context.values_at :by_name, :by_description, :by_tag
      context[:groups] = (by_name + by_description + by_tag).uniq
    end
  end
end
