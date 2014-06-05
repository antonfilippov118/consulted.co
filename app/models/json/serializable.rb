module JSON
  module Serializable
    def as_node
      attributes.slice(*keys).merge kids
    end

    def kids
      {
        slug: slug,
        depth: depth,
        children: children.map(&:as_node)
      }
    end

    def keys
      [:id, :name, :description, :prioritized, :seeker_gain, :unprioritized].map(&:to_s)
    end
  end
end
