attributes :id, :name, :description, :slug, :depth, :prioritized, :seeker_gain
child :children => :children do
  extends 'groups/child'
end
