attributes :id, :name, :description, :slug, :depth, :prioritized, :seeker_gain, :unprioritized
child :children => :children do
  extends 'groups/child'
end
